#!/usr/bin/env bash
#This ensures that apt will use the mirror that is most closed to you. (Geo mirror ftw)
sed -i '1i deb mirror://mirrors.ubuntu.com/mirrors.txt precise main restricted universe multiverse\ndeb mirror://mirrors.ubuntu.com/mirrors.txt precise-updates main restricted universe multiverse\ndeb mirror://mirrors.ubuntu.com/mirrors.txt precise-backports main restricted universe multiverse\ndeb mirror://mirrors.ubuntu.com/mirrors.txt precise-security main restricted universe multiverse' /etc/apt/sources.list
#grub-pc workaround for precise64 git installation
apt-get -y remove grub-pc
apt-get -y install grub-pc
grub-install /dev/sda # precaution
update-grub
apt-get -y update
apt-get -y upgrade
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get -y install zlib1g-dev libssl-dev libreadline-dev python-software-properties curl ssl-cert libopenssl-ruby libxslt-dev libxml2-dev
apt-get clean
