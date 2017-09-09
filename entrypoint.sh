#!/bin/bash
echo "Configuring the HIN Client (Singleuser Servermodus)"
set ${IDENTITY_FILE:-/home/user_hin/user.hin}
set ${PASSPHRASE:-top_secret}
export IDENTITY_FILE_RO=/home/user_hin/user_read_only.hin
cp -v $IDENTITY_FILE $IDENTITY_FILE_RO
echo "keystore=$IDENTITY_FILE_RO" > /home/user_hin/.hinclient-service-parameters.txt
echo "$PASSPHRASE" > /home/user_hin/passphrase.txt
echo "passphrase=/home/user_hin/passphrase.txt" >> /home/user_hin/.hinclient-service-parameters.txt
cat /home/user_hin/.hinclient-service-parameters.txt
chmod 600 /home/user_hin/passphrase.txt $IDENTITY_FILE_RO
/usr/local/HIN\ Client/hinclientservice run-redirect

status=$?
echo START status is $status
rm -f  /home/user_hin/.HIN/HIN\ Client/hinclient.log
while :
do
  sleep 5
  /usr/local/HIN\ Client/hinclientservice status
  status=$?
  echo Status of hinclient is $status
  if [ $status -ne 0 ]
  then
    echo Exist as status of hinclient was $status
    exit $status
  else
    echo Okay
  fi
done

