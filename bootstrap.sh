#!/bin/bash

# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.16.1.100 master
172.16.1.101 worker1
172.16.1.102 worker2
EOF

# Install containerd
echo "[TASK 2] Install dontainerd"
# Configure persistent loading of modules
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

# Load at runtime
sudo modprobe overlay
sudo modprobe br_netfilter

# Ensure sysctl params are set
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload configs
sudo sysctl --system

# Install required packages
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# Add Docker repo
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install containerd
sudo yum update -y && yum install -y containerd.io

# Configure containerd and start service
sudo mkdir -p /etc/containerd
sudo containerd config default > /etc/containerd/config.toml

# restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd



# Disable SELinux
echo "[TASK 3] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

# Stop and disable firewalld
echo "[TASK 4] Stop and Disable firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld

# Add sysctl settings
echo "[TASK 5] Add sysctl settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

# Disable swap
echo "[TASK 6] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Add yum repo file for Kubernetes
echo "[TASK 7] Add yum repo file for kubernetes"
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Install Kubernetes
echo "[TASK 8] Install Kubernetes (kubeadm, kubelet and kubectl)"
yum install -y -q kubeadm kubelet kubectl >/dev/null 2>&1

# Start and Enable kubelet service
echo "[TASK 9] Enable and start kubelet service"
systemctl enable kubelet >/dev/null 2>&1
systemctl start kubelet >/dev/null 2>&1

# Enable ssh password authentication
echo "[TASK 9] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
echo "[TASK 10] Set root password"
echo "kubeadmin" | passwd --stdin root >/dev/null 2>&1

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc