#!/bin/sh
# 
# launch in PROJECT_ROOT
#

if [ ${0:0:7} != "deploy/" ] ; then
	echo "Deploy script must be started in PROJECT_ROOT"
	exit 1
fi


# CONFIG START
# ============

# import config settings
CONFIG="`dirname $0`/config.sh"
if [ -e $CONFIG ] ; then
	. $CONFIG
else
	echo "ERROR: could not read config file [$CONFIG]"
	exit 1
fi

# CONFIG END
# ==========

# check if all required config settings have been set
ok=1
for c in DEPLOY_BASE_DIR SYMLINK CONFIG_SRC CONFIG_DEST SCP_HOST SCP_USER; do
	if [ "${!c}" == "" ] ; then  echo "Error: config setting $c not set. Aborting."; ok=0 ; fi
# done
# check if directories exist
for c in DEPLOY_BASE_DIR ; do
	if ! -d ${!c} ; then  echo "Error: configured directory ${!c} (should be $c) not found. Aborting."; ok=0 ; fi
done
if [ $ok == 0 ] ; then
	exit 1
fi



ts=`date '+%Y%m%d-%H%M%S'`
TARGET_DIR=$DEPLOY_BASE_DIR/$ts

echo "TARGET_DIR: $TARGET_DIR"

ssh $SCP_HOST -l $SCP_USER "mkdir $TARGET_DIR"

# add version file
# ----------------
VERSION=`cat bower.json | grep \"version\" | perl -p -e 's/^.*version.*\b(\d+\.\d+\.\d+)\b.*$/\1/g;'`
ts_json=`date '+%Y-%m-%d %H:%M:%S'`

# ask for additional comment
read -p "Comment this version (or leave blank): " COMMENT

echo '{' >${VERSION_JSON}
echo "  \"version\": \"$VERSION\"," >>${VERSION_JSON}
if [ -n "$COMMENT" ] ; then
	echo "  \"comment\": \"$COMMENT\"," >>${VERSION_JSON}
fi
echo "  \"deployed\": \"$ts_json\"" >>${VERSION_JSON}
echo '}' >>${VERSION_JSON}
echo "------------------------------------"
echo "Extracted version: $a"
echo "Written version file ${VERSION_JSON}"
echo "------------------------------------"

scp -r dist/* "$SCP_USER@$SCP_HOST:$TARGET_DIR"

# fix file permissions
ssh $SCP_HOST -l $SCP_USER "find $TARGET_DIR -type d -exec chmod 755 {} \;; find $TARGET_DIR -type f -exec chmod 644 {} \;"

# add config file
echo "Copying config files"
CONFIG_DEST=$TARGET_DIR/$CONFIG_DEST
ssh $SCP_HOST -l $SCP_USER "cp -r $CONFIG_SRC/* $CONFIG_DEST"

echo "Adapting symlink to current app version"
ssh $SCP_HOST -l $SCP_USER "rm $SYMLINK && ln -s $ts $SYMLINK"

echo ----------------------
echo FINISHED
echo ----------------------
exit 0
