#!/bin/sh

HOSTNAME=""
IPADDRESS=""
USER=""
PASSWORD=""
SIZE=""

usage() {
    echo "Usage: create_seeded_centos_vm.sh -n <hostname> -u <user> -p <password> -s <size>"
    echo "Example: create_seeded_centos_vm.sh -n test -u centos -p pass123 -s 30G"
}

validate() {
    error=0

    if [ "${HOSTNAME}" = "" ]; then
        echo "Missing -n <hostname>"
        error=1
    fi

    if [ "${IPADDRESS}" = "" ]; then
        echo "Missing -i <ipaddress>"
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
while getopts ":hn:i:u:p:s:" option; do
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

NEW_PASSWORD=`mkpasswd --method=SHA-512 --rounds=4096 --stdin $PASSWORD`

# Copy our template to /tmp
cp user-data /tmp/$HOSTNAME/user-data
cp meta-data /tmp/$HOSTNAME/meta-data
cp network_config_static.cfg /tmp/$HOSTNAME/network_config_static.cfg

sed -i "s|##HOSTNAME##|${HOSTNAME}|g" /tmp/$HOSTNAME/user-data
sed -i "s|##IPADDRESS##|${IPADDRESS}/24|g" /tmp/$HOSTNAME/user-data
sed -i "s|##PUBKEY##|${PUBKEY}|g" /tmp/$HOSTNAME/user-data
sed -i "s|##USER##|${USER}|g" /tmp/$HOSTNAME/user-data
sed -i "s|##PASSWORD##|${NEW_PASSWORD}|g" /tmp/$HOSTNAME/user-data
sed -i "s|##IPADDRESS##|${IPADDRESS}|g" /tmp/$HOSTNAME/network_config_static.cfg

# insert network and cloud config into seed image
sudo rm -f /tmp/$HOSTNAME/cloud-init.iso

sudo cloud-localds -v --network-config=/tmp/$HOSTNAME/network_config_static.cfg /tmp/$HOSTNAME/cloud-init.iso /tmp/$HOSTNAME/user-data

sleep 1

# Copy the generic cloud image
sudo cp -f /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud-2009.qcow2 \
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
  --os-variant centos7 \
  --network=bridge=br0,model=virtio
