#!/bin/bash
if [ ! -f /mysql-root-pw.txt ]; then
#let's create a user to ssh into
SSH_USERPASS=`pwgen -c -n -1 8`
mkdir /home/user
useradd -G sudo -d /home/user user
chown user /home/user
echo user:$SSH_USERPASS | chpasswd
echo ssh user password: $SSH_USERPASS
#mysql has to be started this way as it doesn't work to call from /etc/init.d
/usr/bin/mysqld_safe &
sleep 10s
# generate password
MYSQL_PASSWORD=`pwgen -c -n -1 12`
echo mysql root password: $MYSQL_PASSWORD
echo $MYSQL_PASSWORD > /mysql-root-pw.txt
mysqladmin -u root password $MYSQL_PASSWORD
killall mysqld
sleep 10s
fi
supervisord -n
