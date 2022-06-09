#!/bin/sh

HOSTNAME=""
USER=""
PASSWORD=""
SIZE=""

usage() {
    echo "Usage: create_seeded_ubuntu_vm.sh -n <hostname> -u <user> -p <password> -s <size>"
    echo "Example: create_seeded_ubuntu_vm.sh -n test -u ubuntu -p pass123 -s 30G"
}

validate() {
    error=0

    if [ "${HOSTNAME}" = "" ]; then
        echo "Missing -n <hostname>"
        error=1
    fi

    if [ "${USER}" = "" ]; then
        echo "Missing -u <user>"
        error=1
    fi

    if [ "${PASSWORD}" = "" ]; then
        echo "Missing -p <password>"
        error=1
    fi


    if [ "${SIZE}" = "" ]; then
        echo "Missing -s <size>"
        error=1
    fi

    if [ "$error" -eq 1 ]; then
        usage
        exit
    fi
    
}
while getopts ":hn:u:p:s:" option; do
    case $option in
        h)
            usage
            exit;;
        n)
            HOSTNAME="${OPTARG}"
            ;;
        u)
            USER="${OPTARG}"
            ;;
        p)
            PASSWORD="${OPTARG}"
            ;;
        s)
            SIZE="${OPTARG}"
            ;;
        \?)
            echo "Invalid option: ${OPTARG}"
            usage
            exit;;

   esac
done

shift $((OPTIND -1))

validate

echo "Creating VM..."

PUBKEY=`cat $HOME/.ssh/id_rsa.pub`

mkdir -p /tmp/$HOSTNAME

# Copy our template to /tmp
cp user-data /tmp/$HOSTNAME/user-data
cp meta-data /tmp/$HOSTNAME/meta-data
#cp network-config /tmp/$HOSTNAME/network-config

sed -i "s|##HOSTNAME##|$HOSTNAME|g" /tmp/$HOSTNAME/user-data
sed -i "s|##PUBKEY##|${PUBKEY}|g" /tmp/$HOSTNAME/user-data
sed -i "s|##USER##|${USER}|g" /tmp/$HOSTNAME/user-data
sed -i "s|##PASSWORD##|${PASSWORD}|g" /tmp/$HOSTNAME/user-data

# insert network and cloud config into seed image
sudo rm -f /tmp/$HOSTNAME/cloud-init.iso

sudo xorriso -as genisoimage -output /tmp/$HOSTNAME/cloud-init.iso -volid CIDATA -joliet -rock /tmp/$HOSTNAME/user-data /tmp/$HOSTNAME/meta-data

sleep 1

# Copy the generic cloud image
sudo cp -f /var/lib/libvirt/boot/ubuntu-21.10-server-cloudimg-amd64.img \
  /var/lib/libvirt/boot/snapshot-${HOSTNAME}-cloudimg.qcow2

# Resize the cloud image
sudo qemu-img resize /var/lib/libvirt/boot/snapshot-${HOSTNAME}-cloudimg.qcow2 $SIZE

sleep 1

sudo virt-install --name $HOSTNAME --virt-type kvm --memory 4098 --vcpus 2 \
  --boot hd,menu=on \
  --disk path=/tmp/$HOSTNAME/cloud-init.iso,device=cdrom \
  --disk path=/var/lib/libvirt/boot/snapshot-${HOSTNAME}-cloudimg.qcow2,device=disk \
  --graphics none \
  --console=pty,target_type=serial \
  --os-variant ubuntu21.10 \
  --network=bridge=br0,model=virtio