#!/bin/bash

# Check parameter
GITEE_PATH=$1
if [ ! $GITEE_PATH ]; then
  printf "\033[31mERROR: gitee-path cannot not be empty.\033[0m\n"
  exit 1
fi

FINAL=${GITEE_PATH: -1}
if [ $FINAL = '/' ]; then
  GITEE_PATH=${GITEE_PATH%?}
fi

# Check path
APP_PATH=$GITEE_PATH/app
CONFIG_APTH=$GITEE_PATH/config
DB_APTH=$GITEE_PATH/db
if [ ! -d $APP_PATH ] || [ ! -d $CONFIG_PATH ] || [ ! -d $DB_PATH ]; then
  printf "\033[31mERROR: $GITEE_PATH is not the gitee-path.\033[0m\n"
  exit 1
fi

# Backup
BACKUP_DIR="$(dirname $GITEE_PATH)/backup/`date "+%Y%m%d%H%M%S"`"
echo mkdir -p $BACKUP_DIR
mkdir -p $BACKUP_DIR
echo cp -r $GITEE_PATH $BACKUP_DIR
cp -r $GITEE_PATH $BACKUP_DIR
if [ $? -ne 0 ]; then
  printf "\033[31mERROR: Gitee backup failed.\033[0m\n"
  exit 1
fi

# Delete webpacks dir
WEBPACK_PATH=$GITEE_PATH/public/webpacks
if [ -d files/public/webpacks  ] && [ -d $WEBPACK_PATH  ]; then
  rm -rf $WEBPACK_PATH
  echo rm -rf $WEBPACK_PATH
fi

# Delete files with delete.txt
DELETE_FILE=delete.txt
if [ -f $DELETE_FILE ]; then
  while read LINE
  do
    rm -rf $GITEE_PATH/$LINE
    echo rm -rf $GITEE_PATH/$LINE
  done < $DELETE_FILE
fi

# Update files
cp -rf files/* $GITEE_PATH
echo cp -rf files/\* $GITEE_PATH

exit 0

