#!/bin/sh

HOSTNAME=""
SIZE="10"
MEMORY="4096"
CPU="2"
CLOUD_IMAGE="Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
ISO="Rocky-9.4-x86_64-dvd.iso"

usage() {
    echo "Usage: install.sh -n <hostname> -i <ipaddress>"
    echo "Example: install.sh -n jenkins-server -i 192.168.1.50"
}

validate() {
    error=0

    if [ "${HOSTNAME}" = "" ]; then
        error=1
    elif [ "${IPADDRESS}" = "" ]; then
        error=1
    fi

    if [ "$error" -eq 1 ]; then
        usage
        exit
    fi
}

while getopts ":hn:i:" option; do
    case $option in
        h)
            usage
            exit;;
        n)
            HOSTNAME="${OPTARG}"
            ;;
        i)
            IPADDRESS="${OPTARG}"
            ;;
        \?)
            echo "Invalid option: ${OPTARG}"
            usage
            exit;;
   esac
done

shift $((OPTIND -1))

echo $HOSTNAME

CWD=`pwd`

validate

echo "Creating VM..."

PUBKEY=`cat $HOME/.ssh/id_rsa.pub`

# Copy our template to /tmp
mkdir -p /tmp/$HOSTNAME
cp ks.cfg /tmp/$HOSTNAME/ks.cfg

sed -i "s|##HOSTNAME##|${HOSTNAME}|g" /tmp/$HOSTNAME/ks.cfg
sed -i "s|##IPADDRESS##|${IPADDRESS}|g" /tmp/$HOSTNAME/ks.cfg
sed -i "s|##PUBKEY##|${PUBKEY}|g" /tmp/$HOSTNAME/ks.cfg

# Copy the generic cloud image
sudo cp -f /data/libvirt/default/images/${CLOUD_IMAGE} /data/libvirt/default/images/${HOSTNAME}.qcow2

# Resize the cloud image
sudo qemu-img resize /data/libvirt/default/images/${HOSTNAME}.qcow2 ${SIZE}G

sudo virt-install --name ${HOSTNAME} --virt-type kvm --memory $MEMORY --vcpus $CPU \
    --boot hd,menu=on \
    --os-variant rocky9 \
    --location /data/libvirt/default/boot/${ISO} \
    --network=bridge=br0,model=virtio \
    --graphics vnc \
    --disk path=/data/libvirt/default/images/${HOSTNAME}.qcow2,format=qcow2,sparse=true,bus=scsi,discard=unmap,size="${SIZE}" \
    --disk path=/data/libvirt/default/boot/${ISO},device=cdrom \
    --initrd-inject /tmp/${HOSTNAME}/ks.cfg --extra-args "inst.ks=file:ks.cfg" &


