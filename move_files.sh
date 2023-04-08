IP=192.168.18.5

ssh-keygen -R $IP
scp -r ../my-archlinux/* root@$IP:/tmp