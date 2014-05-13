#!/bin/sh
#
# AZ:
# Deploy an app "as is" from the stage location to the productive location.
# Only the config will be adapted.
#

# CONFIG START
# ============

# import config settings
. ./config.sh

# CONFIG END
# ==========


# check if all required config settings have been set
ok=1
for c in STAGED_APP DEPLOY_BASE_DIR SYMLINK CONFIG_SRC CONFIG_DEST ; do
	if [ "${!c}" == "" ] ; then  echo "Error: config setting $c not set. Aborting."; ok=0 ; fi
done
# check if directories exist
for c in STAGED_APP DEPLOY_BASE_DIR ; do
	if ! -d ${!c} ; then  echo "Error: configured directory ${!c} (should be $c) not found. Aborting."; ok=0 ; fi
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

echo "Adapting symlink to current app version"
rm $SYMLINK
ln -s $ts $SYMLINK

echo RESTARTING instance
sudo service idot restart
exit 0

~
~
~
~




# Context: this git repo
TMP_DIR=`mktemp -d`
git archive HEAD | tar x -C $TMP_DIR

# Context: $TMP_DIR
cd $TMP_DIR

cd app
find -type f -name '.gitignore' -exec rm {} \;
if ! npm install --production ; then
	echo "Error at npm install. Aborting."
	exit 2
fi
mv $TMP_DIR/node_modules/ $TMP_DIR/app/

# add version file
if [ "$VERSION_JSON" ] ; then
	VERSION=`cat ../package.json | grep \"version\" | perl -p -e 's/^.*version.*\b(\d+\.\d+\.\d+)\b.*$/\1/g;'`
	ts_json=`date '+%Y-%m-%d %H:%M:%S'`
	echo '{' >${VERSION_JSON}
	echo "  \"version\": \"$VERSION\"," >>${VERSION_JSON}
	echo "  \"deployed\": \"$ts_json\"" >>${VERSION_JSON}
	echo '}' >>${VERSION_JSON}
	echo "------------------------------------"
	echo "Extracted version: $a"
	echo "Written version file ${VERSION_JSON}"
	echo "------------------------------------"
else
	echo "No version info filename configured => no version info file written."
fi

# now copy the app "as is" into the app directory
ts=`date '+%Y%m%d-%H%M%S'`
TARGET_DIR=$DEPLOY_BASE_DIR/$ts
mkdir $TARGET_DIR
echo "Deploying to $TARGET_DIR ..."
cp -r . $TARGET_DIR

# Context: $DEPLOY_BASE_DIR
cd $DEPLOY_BASE_DIR

# add config file
echo "Copying config files"

# mkdir if not exists:
mkdir -p $TARGET_DIR/$CONFIG_DEST
cp -r $CONFIG_SRC/* $TARGET_DIR/$CONFIG_DEST

echo "Adapting symlink to current app version"
rm $SYMLINK
ln -s $TARGET_DIR $SYMLINK

echo Removing tmp dir [$TMP_DIR]
rm -fr $TMP_DIR

echo RESTARTING instance
sudo service $APP_SERVICE_NAME restart

echo
echo '---------------------------------------------'
echo 'Deployment finished.'
echo '---------------------------------------------'
exit 0
