#!/bin/bash

GITEE_PATH=$1
if [ ! $GITEE_PATH ]; then
  printf "\033[31mERROR: gitee-path cannot not be empty.\033[0m\n"
  exit 1
fi

FINAL=${GITEE_PATH: -1}
if [ $FINAL = '/' ]; then
  GITEE_PATH=${GITEE_PATH%?}
fi

APP_PATH=$GITEE_PATH/app
CONFIG_APTH=$GITEE_PATH/config
DB_APTH=$GITEE_PATH/db
if [ ! -d $APP_PATH ] || [ ! -d $CONFIG_PATH ] || [ ! -d $DB_PATH ]; then
  printf "\033[31mERROR: $GITEE_PATH is not the gitee-path.\033[0m\n"
  exit 1
fi

cp -r files/* $GITEE_PATH
echo cp -r files/\* $GITEE_PATH

DELETE_FILE=delete.txt
if [ -f $DELETE_FILE ]; then
  while read LINE
  do
    rm -rf $GITEE_PATH/$LINE
    echo rm -rf $GITEE_PATH/$LINE
  done < $DELETE_FILE
fi

exit 0

