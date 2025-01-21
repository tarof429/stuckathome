# Post install

- Start and enable netctl

    ```
    systemctl enable netctl
    systemctl start netctl
    ```

- Start and enable enp4s0: 
    
    ```
    netctl enable enp4s0
    netctl start enp4s0
    ```

    By the way, enp4s0 is the name of the profile you want to enable. You can create other profiles too and enable and disable them using netctl. See the section on kvm to read on how to set up bridge networking.

    Note: do not enable or start systemd-networkd when using netctl

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

- Install mate according to https://www.tecmint.com/install-mate-desktop-in-arch-linux/. This requires xorg, xorg-xinit and mesa for Nvidia GPUs.

- Intall pulseaudio, pulseaudio-alsa and pavolume for sound. Use mate control panel to disable mute.

- Installed ufw, with these rules:

    ```
    sudo ufw default allow outgoing
    sudo ufw default deny incoming
    sudo ufw allow from 192.168.0.0/24 to any port 22
    sudo ufw status
    ```

    Or use gufw, a frontend for ufw.

- Install some more fonts: https://blog.yucas.net/2018/03/25/beautiful-fonts-improve-arch-linux/. Also install noto-fonts-cjk for Japanese, and ttf-hack for VS Code


- Install `code` for editing

- Install squahsfs-tools to restore files from backup

- Install shotwell to view photos

- Install inetutils for `hostname`

- For a system that has an AMD GPU, run `pacman -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon`

- To rip CDs, install cdparanoia and run `sudo cdparanoia -B`. Files will be saved in the current working diretory. The wav files can be converted to mp3 files by running `for f in *.wav; do lame $f; done`. Another tool that can be used to convert wav files to mp3 is abcde. 

To install abcde, you need to build the aur from https://aur.archlinux.org/abcde.git. This package has a dependency on cd-discid and vorbis-tools. The vorbis-tools package can be installed easily using `pacman -S vorbis-tools`. For cd-discid, you need to build the aur https://aur.archlinux.org/cd-discid.git. Finally, to install abcde, you need to install a PGP signature as mentioned at https://bbs.archlinux.org/viewtopic.php?id=261267 which is referring to the GPG keys for either Steve or Andrew on the abcde download page at https://abcde.einval.com/download/. Search for this key at https://keys.openpgp.org, download the file, and import the key by running `gpg --import <file>`. You should now be able to install abcde. 

You also need to install a configuration file for abcde. For example, see http://andrews-corner.org/abcde.html and https://bbs.archlinux.org/viewtopic.php?id=202331 and copy it to ~/.abcde.conf. 

- Get bluetooth audio working. See https://www.jeremymorgan.com/tutorials/linux/how-to-bluetooth-arch-linux/.

- To configure ufw, see https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu

- Amberol is a nice music player.

# References

https://github.com/korvahannu/arch-nvidia-drivers-installation-guide

https://www.baeldung.com/linux/squashfs-filesystem-mount

https://wiki.archlinux.org/title/Nouveau

https://forum.endeavouros.com/t/beginner-s-guide-to-setting-up-and-using-mpd/16831