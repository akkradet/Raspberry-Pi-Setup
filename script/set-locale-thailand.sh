#!/bin/sh
# run script under root
# this is my personal preference.
#
# System setting
## timezone
/bin/echo Asia/Bangkok > /etc/timezone
/bin/rm /etc/localtime
/bin/ln -s /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
 
## locale
/bin/echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
/bin/echo th_TH.UTF-8 UTF-8 >> /etc/locale.gen
/usr/sbin/locale-gen
 
apt update
apt upgrade
apt -y install vim screenfetch inxi