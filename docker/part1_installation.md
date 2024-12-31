# Part 1: Installation

## Running docker on AWS.

The AWS Marketplace has AMIs with docker pre-installed. but we'll forgot that and instead create instances and do the installation ourself. Below are steps to do install docker on an Ubuntu instance.

1.  Create an Ubuntu 20.04 LTS instance with t2.medium.

2. SSH to the instance and run `sudo apt upgrade to update all packages.

3. Reboot

4. Install docker based on the instructions at https://docs.docker.com/engine/install/ubuntu/

## Running docker on ArchLinux

1. Install docker package

    ```
    sudo pacman -S docker
    ```

2. Enable and start the Docker daemon

    ```
    sudo systemctl start docker
    ```

3. Add yourself to the docker group.

    ```
    sudo usermod -aG docker <username>
    ```

4. Logout and log back in again

5. Pull the hello-world image

    ```
    docker run hello-world
    ```

## Relocating docker storage

Create a file at /etc/daemon.json with the location of data-root. For example:

```json
{
  "data-root": "/data/docker"
}
```

## References

https://aws.amazon.com/marketplace/pp/prodview-cuiyfwsltafu4,