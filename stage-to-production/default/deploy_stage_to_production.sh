#!/bin/sh
#
# AZ:
# Deploy an app "as is" from the stage location to the productive location.
# Only the config will be adapted by overwriting stage config files by
# production config file.
#

# CONFIG START
# ============

# import config settings
. "`dirname $0`/config.sh"  

# CONFIG END
# ==========


# check if all required config settings have been set
ok=1
for c in STAGED_APP DEPLOY_BASE_DIR SYMLINK CONFIG_SRC CONFIG_DEST ; do
	if [ -z "${!c}" ] ; then  echo "Error: config setting $c not set. Aborting."; ok=0 ; fi
done
# check if directories exist
for c in STAGED_APP DEPLOY_BASE_DIR FAVICON_DIR ; do
	if [ -n "$!c}" -a ! -d ${!c} ] ; then
		echo "Error: configured directory ${!c} (should be $c) not found. Aborting."; 
		ok=0 ; 
	fi
done
if [ $ok == 0 ] ; then
	exit 1
fi

echo 'Starting deployment stage -> production ...'

ts=`date '+%Y%m%d-%H%M%S'`
TARGET_DIR=$DEPLOY_BASE_DIR/$ts
mkdir $TARGET_DIR
echo "Deploying from $STAGED_APP to $TARGET_DIR ..."
cp -r $STAGED_APP/* $TARGET_DIR


# Context: $DEPLOY_BASE_DIR
cd $DEPLOY_BASE_DIR

# add config file
echo "Copying config files"
# mkdir if not exists:
mkdir -p $TARGET_DIR/$CONFIG_DEST
cp -r $CONFIG_SRC/* $TARGET_DIR/$CONFIG_DEST

if [ -n "$FAVICON_DIR" ] ; then
	echo "Copying favicon files"
	cp $FAVICON_DIR/* $TARGET_DIR
fi


echo "Adapting symlink to current app version"
rm $SYMLINK
ln -s $ts $SYMLINK

if [ ! -z "$APP_SERVICE_NAME" ] ; then
	echo RESTARTING instance
	sudo service $APP_SERVICE_NAME restart
else
	echo "Nothing to restart."
fi

echo
echo '---------------------------------------------'
echo 'Deployment finished.'
echo '---------------------------------------------'
exit 0
