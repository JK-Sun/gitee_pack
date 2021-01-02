#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

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

# Backup
BACKUP_DIR="$(dirname $GITEE_PATH)/backup/`date "+%Y%m%d%H%M%S"`/$(basename $GITEE_PATH)"
echo mkdir -p $BACKUP_DIR
mkdir -p $BACKUP_DIR
echo "cd $GITEE_PATH && tar --exclude tmp -cf - * | tar -xf - -C $BACKUP_DIR"
cd $GITEE_PATH && tar --exclude tmp -cf - * | tar -xf - -C $BACKUP_DIR
if [ $? -ne 0 ]; then
  printf "\033[31mERROR: Gitee backup failed.\033[0m\n"
  exit 1
fi

echo cd $SCRIPT_DIR
cd $SCRIPT_DIR

# Delete webpacks dir
WEBPACK_PATH=$GITEE_PATH/public/webpacks
if [ -d files/public/webpacks  ] && [ -d $WEBPACK_PATH  ]; then
  rm -rf $WEBPACK_PATH
  echo rm -rf $WEBPACK_PATH
fi

# Delete assets dir
ASSET_PATH=$GITEE_PATH/public/assets
if [ -d files/public/assets  ] && [ -d $ASSET_PATH  ]; then
  rm -rf $ASSET_PATH
  echo rm -rf $ASSET_PATH
fi

# Delete bundle cache dir
BUNDLE_CACHE_PATH=$GITEE_PATH/vendor/cache
if [ -d files/vendor/cache  ] && [ -d $BUNDLE_CACHE_PATH  ]; then
  rm -rf $BUNDLE_CACHE_PATH
  echo rm -rf $BUNDLE_CACHE_PATH
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

