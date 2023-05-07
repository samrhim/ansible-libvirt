#!/bin/sh
echo "Control Node Preparation ..."
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

dnf update -y
dnf install -y epel-release wget figlet
dnf makecache
dnf install -y python39 python39-pip git bind-utils vim bash-completion neofetch nano
wget http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/sshpass-1.09-4.el8.x86_64.rpm
rpm -i sshpass-1.09-4.el8.x86_64.rpm

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

export PATH="/usr/local/bin:$PATH"
source  ~/.bash_profile

# python3 -m pip install  ansible

PASS=$(echo "centos" | openssl passwd -1 -stdin)
useradd -p "$PASS" student
cat <<EOF > /etc/sudoers.d/student
student	ALL=NOPASSWD: ALL
EOF
echo neofetch >> /home/student/.bashrc
echo figlet -c  "Welcome to Ansible Control Node" >> /home/student/.bashrc

# cat <<EOF > /etc/hosts
# 192.168.56.200 control.clevory.local
# 192.168.56.201 ansible1.clevory.local
# 192.168.56.202 ansible2.clevory.local
# EOF

# su - ansible -c "ssh-keygen -b 2048 -t rsa -f /home/ansible/.ssh/id_rsa -q -P \"\""
# su - ansible -c "ssh-keyscan ansible1.clevory.local 2>/dev/null >> home/ansible/.ssh/known_hosts"
# su - ansible -c "ssh-keyscan ansible2.clevory.local 2>/dev/null >> home/ansible/.ssh/known_hosts"
# su - ansible -c "echo 'ansible' |sshpass ssh-copy-id -f -i /home/ansible/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ansible@ansible1.clevory.local"
# su - ansible -c "echo 'ansible' |sshpass ssh-copy-id -f -i /home/ansible/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ansible@ansible2.clevory.local"
# su - ansible -c "git clone https://github.com/sandervanvugt/rhce8-live.git"
