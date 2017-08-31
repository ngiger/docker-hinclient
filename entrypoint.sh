#!/bin/bash
echo "Configuring the HIN Client (Singleuser Servermodus)"
export IDENTITY_FILE=/root/user.hin
export IDENTITY_FILE_RO=/root/user_read_only.hin
cp $IDENTITY_FILE $IDENTITY_FILE_RO
echo "keystore=$IDENTITY_FILE_RO" > /root/.hinclient-service-parameters.txt
echo "$PASSPHRASE" > /root/passphrase.txt
echo "passphrase=/root/passphrase.txt" >> /root/.hinclient-service-parameters.txt
cat /root/.hinclient-service-parameters.txt
# chown -R user_hin /root/passphrase.txt $IDENTITY_FILE_RO /root/.HIN
chmod 600 /root/passphrase.txt $IDENTITY_FILE_RO
/root/start_hin.sh
status=$?
echo START status is $status
rm -f  /root/.HIN/HIN\ Client/hinclient.log
while :
do
  sleep 5
  /root/HIN\ Client/hinclientservice status
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

