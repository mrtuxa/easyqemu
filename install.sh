#!/bin/bash
echo installing qemu
sudo pacman -Syyu
sudo pacman -S base-devel
cd ~
mkdir git
cd git
sudo pacman -S git 
git clone https://aur.archlinux.org/yay.git
cd yay
echo installing yay aka aur helper
clear
makepkg -si
clear
cd ..
sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat
sudo pacman -S ebtables iptables
sudo pacman -Syy
yay -S --noconfirm --needed libguestfs
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
cd /etc/libvirt
sudo rm libvirtd.conf
sudo pacman -S wget
sudo wget https://raw.githubusercontent.com/2duo/easyqemu/main/libvirtd.conf
sudo usermod -a -G libvirt $(whoami)
newgrp libvirt
sudo systemctl restart libvirtd.service
echo Confirm that Nested Virtualization is set to Yes:

echo $ systool -m kvm_intel -v | grep nested
echo    nested              = "Y"
echo    nested_early_check  = "N"
echo$ cat /sys/module/kvm_intel/parameters/nested 
echo Y
sleep 1
clear
sudo modprobe -r kvm_intel
sudo modprobe kvm_intel nested=1
echo "options kvm-intel nested=1" | sudo tee /etc/modprobe.d/kvm-intel.conf
systool -m kvm_intel -v | grep nested
cat /sys/module/kvm_intel/parameters/nested
clear
echo now is qemu install launch now virtual machine manager
