#!/bin/bash
# (c) copyright 2014/2015 by Fabian Schmid <f.schmid@netzkonzept.ch>
# Thanks to Fabian Schmid, who sent the original version of the script to Niklaus Giger
# HIN Client Install Script

######################################################
#
# Config Section
#
######################################################

# Name of the (already activated) idendity file
IDENDITY_FILE={{ client.get('id_file', 'nikgiger.hin') }}

# Where to find the idendity file for coping
IDENDITY_FILE_SOURCE_PATH={{ client.get('id_file_source', '/vagrant/saltstack/salt/') }}

# Local User for running the hin server
HIND_USER={{ client.get('hind', 'hind') }}

# Where to get the hinclient from, check 4 new versions
HIN_CLIENT_DOWNLOAD_URL={{ client.get('url', 'https://download.hin.ch/download/distribution/install/1.4.0-0/HINClient_unix_1_4_0-0.tar.gz') }}

# Redir Ports, on these ports the services will be available
REDIR_HTTP={{ client.get('http_port', '8016') }}
REDIR_POP3={{ client.get('pop3_port', '8018') }}
REDIR_SMTP={{ client.get('smtp_port', '8019') }}
REDIR_IMAP={{ client.get('imap_port', '8020') }}

######################################################
#
# Script Section
#
######################################################

echo "Createing user $HIND_USER"
useradd -m $HIND_USER

echo "Downloading and unpacking the Hin client"
wget -q -P /home/$HIND_USER $HIN_CLIENT_DOWNLOAD_URL > /dev/null
cd /home/$HIND_USER
tar xf *.tar.gz
rm *.tar.gz

echo "Configuring the HIN Client (Singleuser Servermodus)"
cp $IDENDITY_FILE_SOURCE_PATH/$IDENDITY_FILE /home/$HIND_USER/$IDENDITY_FILE
echo "keystore=/home/$HIND_USER/$IDENDITY_FILE" > /home/$HIND_USER/.hinclient-service-parameters.txt
echo "passphrase=/home/$HIND_USER/passphrase.txt" >> /home/$HIND_USER/.hinclient-service-parameters.txt
read -s -p "Enter Passphrase for HIN Idendity $IDENDITY_FILE: " PASSPHRASE
echo "$PASSPHRASE" > /home/$HIND_USER/passphrase.txt
chmod 600 /home/$HIND_USER/passphrase.txt
chmod 600 /home/$HIND_USER/$IDENDITY_FILE

# Set User as Owner
chown -R $HIND_USER /home/$HIND_USER
chgrp -R $HIND_USER /home/$HIND_USER

echo "Starting the Hin Server"
sudo -u $HIND_USER /home/$HIND_USER/HIN\ Client/hinclientservice start

echo "Installing required packages inetd, redir"
apt-get install inetutils-inetd redir

echo "Configuring inetd"
echo "# Redir config for sharing local HIN Client" >> /etc/inetd.conf
echo "$REDIR_HTTP stream tcp nowait root /usr/bin/redir --lport=$REDIR_HTTP --cport=5016 --caddr=localhost --inetd" >> /etc/inetd.conf
echo "$REDIR_POP3 stream tcp nowait root /usr/bin/redir --lport=$REDIR_POP3 --cport=5018 --caddr=localhost --inetd" >> /etc/inetd.conf
echo "$REDIR_SMTP stream tcp nowait root /usr/bin/redir --lport=$REDIR_SMTP --cport=5019 --caddr=localhost --inetd" >> /etc/inetd.conf
echo "$REDIR_IMAP stream tcp nowait root /usr/bin/redir --lport=$REDIR_IMAP --cport=5020 --caddr=localhost --inetd" >> /etc/inetd.conf

echo "Restarting service inetd"
service inetutils-inetd restart

echo "Installation finished"
echo "Command to start/stop/restart the Hin Server"
echo "sudo -u $HIND_USER /home/$HIND_USER/HIN\ Client/hinclientservice start | stop | restart"
