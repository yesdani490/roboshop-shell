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

yum install nginx -y &>>$LOGFILE
VALIDATE $? 'Installing Nginx'

systemctl enable nginx &>>$LOGFILE
VALIDATE $? 'Enabling Nginx'

systemctl start nginx &>>$LOGFILE
VALIDATE $? 'Starting Nginx'

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? 'Removing default nginx file'

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE
VALIDATE $? 'Downloading Web artifact'

unzip /tmp/web.zip
VALIDATE $? 'Unzipping web artifact'
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>$LOGFILE
VALIDATE $? 'Copying Roboshop config '

systemctl restart nginx &>>$LOGFILE
VALIDATE $? 'Restarting Nginx'


