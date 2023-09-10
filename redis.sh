#!/bin/bash

DATE=$(date +%F)
SCRIPT_NAME=$0
LOGDIR=/tmp
LOGFILE=$LOGDIR/$SCRIPT_NAME-$DATE.log
USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m" 
#Y="\e[33m"

if [ $USERID -ne 0 ];

then 
  echo -e " $R Error::: Please run the script with root access $N "
  exit 1

fi

VALIDATE(){
   if [ "$1" -ne 0 ];
      then
        echo -e " $2....$R Failure $N"
        exit 1
      else 
      echo -e "   $2 .... $G Success $N"
   fi
}
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

VALIDATE $? 'Installing redis repo'

yum module enable redis:remi-6.2 -y
VALIDATE $? 'Enabling redis 6.2'

yum install redis -y 
VALIDATE $? 'Installing redis '

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf /etc/redis/redis.conf
VALIDATE $? 'Changing  in redis.conf'

systemctl enable redis
VALIDATE $? 'enabling  redis '

systemctl start redis
VALIDATE $? 'starting  redis '
