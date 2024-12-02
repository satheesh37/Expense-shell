#!/bin/bash

LOGS_FOLDER="/var/log/Expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%m-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER


USERID=$(id -u)
    
    R="\e[31m"
    G="\e[32m"
    Y="\e[33m"
    N="\e[0m"

CHECK_ROOT(){
     if [ $USERID -ne 0 ]
    then
        echo -e "$R Please run this script $N" | tee -a $LOG_FILE
        exit 1
     fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is....$R FAILED $N" | tee -a $LOG_FILE 
        exit 1
    else 
        echo -e "$2 is... $G SUCCESS $N" | tee -a $LOG_FILE 
    fi    
}
echo "script started executing at: $(date)" | tee -a $LOG_FILE 

CHECK_ROOT

dnf install mysql-server -y &>>$LOG_FILE 
VALIDATE $? "Installing Mysql Server"

systemctl enable mysqld &>>$LOG_FILE 
VALIDATE $? "enabled Mysql Server"

systemctl start mysql &>>$LOG_FILE 
VALIDATE $? "Started Mysql server"

mysql_secure_installation --set--root-pass ExpenseApp@1 &>>$LOG_FILE 
VALIDATE $? "setting up root password"



