
#!/bin/bash

SOFTWARS=("Docker" "Git")
CONTAINERS=("Jenkins" "nginx")
command_exists(){
    command -v "$1" >/dev/null 2>&1
}
container_exists(){
    local container_name=$1
    sudo docker ps -a --filter name="$container_name" | grep -q "$container_name"
}
#updating the system
sudo apt update -y
#instaling vim and wget
sudo apt install -y wget vim

if ! command_exists docker;
then
    echo "installing docker..."

    sudo apt-get update -y
    sudo apt-get install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    echo "verifying..."
    sudo docker run hello-world
    echo "installed successfully"
else
    echo "docker is installed on the device"
fi

for container_name in "${CONTAINERS[@]}";
do
    if container_exists "$container_name";
    then
        echo "the container '$container_name' is already exist"
    else
        echo " no existing container with the name '$container_name', now creating..."

        if [ "$container_name" == "Jenkins" ];
        then
            sudo docker run --name "$container_name" -d \
                -p 8080:8080 \
                -v jenkins_home:/var/jenkins_home \
                --memory 2g \
                jenkins/jenkins:lts
        elif [ "$container_name" == "nginx" ]
        then 
            sudo docker run -d nginx
    
        fi
    fi
done
if ! command_exists git:
then
    echo "installing Git..."
    sudo apt install -y git
    echo "installed successfully"
else
    echo "Git is already installed"
fi

echo "Ready!"

