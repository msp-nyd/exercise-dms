
## Install docker with a script
```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

#### Test with hello-world docker, it may ask for sudo
```
sudo docker run hello-world
```

#### To run Docker without root privileges
```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

#### Change its ownership and permissions
```
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
```
#### Test with hello-world docker without sudo
```
docker run hello-world
```

#### Configure Docker to start on boot with systemd
```
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

#### Configure Docker to not start on boot with systemd
```
sudo systemctl disable docker.service
sudo systemctl disable containerd.service
```

#### Get version
```
docker version
```

## Install docker compose https://github.com/docker/compose/releases/
```
sudo curl -SL https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

#### Get version
```
docker compose version
```
