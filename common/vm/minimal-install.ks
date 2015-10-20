install
text
#reboot
lang en_US.UTF-8
keyboard us
network --bootproto dhcp

rootpw redhat
firewall --enabled --ssh
selinux --enforcing
timezone --utc Europe/Prague
firstboot --disable
bootloader --location=mbr --append="console=tty0 console=ttyS0,115200 rd_NO_PLYMOUTH"
zerombr
clearpart --all --initlabel
autopart
reboot

#Just core packages
%packages --nobase
openssh
openssh-clients
wget
%end
