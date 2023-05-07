#!/bin/sh

echo "Managed Node Preparation ..."

yum install -y epel-release wget vim nano
yum makecache --refresh
yum update -y
yum install -y python39 bind-utils neofetch

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

PASS=$(echo "control" | openssl passwd -1 -stdin)
useradd -p "$PASS" ansible
cat <<EOF > /etc/sudoers.d/ansible
ansible ALL=NOPASSWD: ALL
EOF

echo neofetch >> /home/ansible/.bashrc
echo figlet -c  "Welcome to Ansible Managed Node" >> /home/ansible/.bashrc

cat <<EOF > /etc/hosts
192.168.10.200 control.clevory.local
192.168.10.201 node1.clevory.local
192.168.10.202 node2.clevory.local
192.168.10.203 node3.clevory.local
EOF
