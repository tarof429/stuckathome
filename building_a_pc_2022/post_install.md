# Post install

- Start and enable enp4s0: 
    
    ```
    netctl enable enp4s0
    netctl start enp4s0
    ```

    By the way, enp4s0 is the name of the profile you want to enable. You can create other profiles too and enable and disable them using netctl. See the section on kvm to read on how to set up bridge networking.

- Install reflector: https://wiki.archlinux.org/title/reflector and https://man.archlinux.org/man/reflector.1#EXAMPLES. For example:

    ```
    sudo reflector --country US --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
    ```

- Setup ntp

    ```
    sudo timedatectl set-ntp yes
    sudo pacman -S ntp
    ```
- Setup pacman colors by editing /etc/pacman.conf and uncommenting Color

- Install mate according to https://www.tecmint.com/install-mate-desktop-in-arch-linux/

- Installed sx, a replacement for startx: https://github.com/Earnestly/sx

- Installed ufw, with these rules:

    ```
    sudo ufw default allow outgoing
    sudo ufw default deny incoming
    sudo ufw allow from 192.168.0.0/24 to any port 22
    sudo ufw status
    ```

    Or use gufw, a frontend for ufw.

- Install some more fonts: https://blog.yucas.net/2018/03/25/beautiful-fonts-improve-arch-linux/. Also install noto-fonts-cjk for Japanese, and ttf-hack for VS Code


- Install either the latest stable kernel or the LTS kernel.

    ```
    sudo pacman -S linux-lts
    ```

- Install `peek`, a tool for taking screenshots
