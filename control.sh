#!/bin/sh
echo "Control Node Preparation ..."

yum update -y
yum install -y epel-release wget figlet
yum makecache
yum install -y python39 python39-pip git ansible=3.2.6 bind-utils vim bash-completion neofetch nano sshpass
# wget http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/sshpass-1.09-4.el8.x86_64.rpm
# rpm -i sshpass-1.09-4.el8.x86_64.rpm

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

export PATH="/usr/local/bin:$PATH"
source  ~/.bash_profile

PASS=$(echo "control" | openssl passwd -1 -stdin)
useradd -p "$PASS" ansible
cat <<EOF > /etc/sudoers.d/ansible
ansible 	ALL=NOPASSWD: ALL
EOF
echo neofetch >> /home/ansible/.bashrc
echo figlet -c  "Welcome to Ansible Control Node" >> /home/ansible/.bashrc

cat <<EOF > /etc/hosts
192.168.10.200 control.clevory.local
192.168.10.201 node1.clevory.local
192.168.10.202 node2.clevory.local
192.168.10.203 node3.clevory.local
EOF

su - ansible -c "ssh-keygen -b 2048 -t rsa -f /home/ansible/.ssh/id_rsa -q -P \"\""
su - ansible -c "ssh-keyscan node1.clevory.local 2>/dev/null >> home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan node2.clevory.local 2>/dev/null >> home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan node3.clevory.local 2>/dev/null >> home/ansible/.ssh/known_hosts"
su - ansible -c "echo 'ansible' |sshpass ssh-copy-id -f -i /home/ansible/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ansible@node1.clevory.local"
su - ansible -c "echo 'ansible' |sshpass ssh-copy-id -f -i /home/ansible/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ansible@node2.clevory.local"
su - ansible -c "echo 'ansible' |sshpass ssh-copy-id -f -i /home/ansible/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ansible@node3.clevory.local"
su - ansible -c "git clone https://github.com/samrhim/rhce8-live.git"
