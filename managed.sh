#!/bin/sh

echo "Managed Node Preparation ..."
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

dnf install -y epel-release wget vim nano
dnf makecache --refresh
dnf update -y
dnf install -y python39 bind-utils neofetch

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

PASS=$(echo "centos" | openssl passwd -1 -stdin)
useradd -p "$PASS" student
cat <<EOF > /etc/sudoers.d/student
student ALL=NOPASSWD: ALL
EOF

echo neofetch >> /home/student/.bashrc
echo figlet -c  "Welcome to Ansible Managed Node" >> /home/student/.bashrc

# PASS=$(echo "ansible" | openssl passwd -1 -stdin)
# useradd -p "$PASS" ansible
# cat <<EOF > /etc/sudoers.d/ansible
# ansible ALL=NOPASSWD: ALL
# EOF

# cat <<EOF > /etc/hosts
# 192.168.56.200 control.clevory.local
# 192.168.56.201 ansible1.clevory.local
# 192.168.56.202 ansible2.clevory.local
# EOF
