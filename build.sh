#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos

# rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


rpm-ostree override remove firefox firefox-langpacks ptyxis
rpm-ostree install distrobox rsms-inter-fonts rsms-inter-vf-fonts gnome-tweaks dconf-editor tmux

cd tmp
wget https://li.nux.ro/download/nux/dextop/el7/x86_64/webcore-fonts-3.0-1.noarch.rpm
rpm-ostree install webcore-fonts-3.0-1.noarch.rpm

wget https://li.nux.ro/download/nux/dextop/el7/x86_64/webcore-fonts-vista-3.0-1.noarch.rpm
rpm-ostree install webcore-fonts-vista-3.0-1.noarch.rpm

cd -

rpm-ostree install papirus-icon-theme adw-gtk3-theme

rpm-ostree install google-noto-fonts-all google-noto-fonts-common

# this would install a package from rpmfusion
# rpm-ostree install vlc

#### Example for enabling a System Unit File

systemctl enable podman.socket
