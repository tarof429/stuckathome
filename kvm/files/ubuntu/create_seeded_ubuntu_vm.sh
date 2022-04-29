#!/bin/sh

HOSTNAME=""
USER=""
PASSWORD=""
IPADDRESS=""
GATEWAY=""
SIZE=""

usage() {
    echo "Usage: create_seeded_ubuntu_vm.sh -n <hostname> -u <user> -p <password> -i <ipaddress> -g <gateway> -s <size>"
    echo "Example: create_seeded_ubuntu_vm.sh -n test -u ubuntu -p pass123 -i 192.168.0.25 -g 192.168.0.1 -s 30G"
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

    if [ "${GATEWAY}" = "" ]; then
        echo "Missing -g <gateway>"
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
while getopts ":hn:u:p:i:g:s:" option; do
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
        i)
            IPADDRESS="${OPTARG}"
            ;;
        g)
            GATEWAY="${OPTARG}"
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


# HOSTNAME=test
PUBKEY=`cat $HOME/.ssh/id_rsa.pub`
# USER=ubuntu
# PASSWORD=test123
# IPADDRESS=192.168.0.25
# GATEWAY=192.168.0.1

mkdir -p /tmp/$HOSTNAME

# Copy our template to /tmp
cp cloud-config /tmp/$HOSTNAME/cloud-config
cp network_config_static.cfg /tmp/$HOSTNAME/network_config_static.cfg

sed -i "s|##HOSTNAME##|$HOSTNAME|g" /tmp/$HOSTNAME/cloud-config
sed -i "s|##PUBKEY##|${PUBKEY}|g" /tmp/$HOSTNAME/cloud-config
sed -i "s|##USER##|${USER}|g" /tmp/$HOSTNAME/cloud-config
sed -i "s|##PASSWORD##|${PASSWORD}|g" /tmp/$HOSTNAME/cloud-config
sed -i "s|##IPADDRESS##|${IPADDRESS}|g" /tmp/$HOSTNAME/network_config_static.cfg
sed -i "s|##GATEWAY##|${GATEWAY}|g" /tmp/$HOSTNAME/network_config_static.cfg


# insert network and cloud config into seed image
sudo rm -f /tmp/$HOSTNAME/seed.img
cloud-localds -v --network-config=/tmp/$HOSTNAME/network_config_static.cfg /tmp/$HOSTNAME/seed.img /tmp/$HOSTNAME/cloud-config

sleep 1

# Copy the generic cloud image
sudo cp /var/lib/libvirt/boot/ubuntu-21.10-server-cloudimg-amd64.img \
  /var/lib/libvirt/boot/snapshot-${HOSTNAME}-cloudimg.qcow2

# Resize the cloud image
sudo qemu-img resize /var/lib/libvirt/boot/snapshot-${HOSTNAME}-cloudimg.qcow2 $SIZE

sleep 1

sudo virt-install --name $HOSTNAME --virt-type kvm --memory 4098 --vcpus 2 \
  --boot hd,menu=on \
  --disk path=/tmp/$HOSTNAME/seed.img,device=cdrom \
  --disk path=/var/lib/libvirt/boot/snapshot-${HOSTNAME}-cloudimg.qcow2,device=disk \
  --graphics none \
  --console=pty,target_type=serial \
  --os-variant ubuntu21.10 \
  --network=bridge=br0,model=virtio