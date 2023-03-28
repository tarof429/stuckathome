# Microservices Demo

## Introduction

This section is based on the online tutorial at https://www.freecodecamp.org/news/learn-kubernetes-in-under-3-hours-a-detailed-guide-to-orchestrating-containers-114ff420e882/. The objective of this example is to deploy microservices to a Kubernetes Cluster. 

## Repository

A fork of the repository has been created at https://github.com/tarof429/k8s-mastery. 

## Tips

1. When the instructions tell you to run `npm install` in the sa-frontend directory, run npm update first to upgrade libraries that are out of date.

2. When the instructiosn tell you to move the build directory to [your_nginx_installation_dir]/html, run these commands:
    - sudo cp -r /usr/share/nginx/html/ /usr/share/nginx/html.bak
    - sudo cp -r build/* /usr/share/nginx/html

Afterwards, you should be able to access the application at http://localhost/

3. Install Java with the sudo jdk-openjdk package

4. Download Maven from https://maven.apache.org/download.cgi

5. To run the Python application, use virtualenv.

    ```
    virtualenv venv
    . ./venv/bin/activate
    pip install -r requirements.txt
    ```

6. Upgrade requirements. Failure to do so might be the reason cannot start.

    ```
    pip install pip-upgrader
    pip-upgrade
    ```

7. 
