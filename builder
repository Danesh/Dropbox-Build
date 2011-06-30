#######################################################################
# DROPBOX  : Folder on dropbox to use to update status and update.zip #
# ANDROID  : Local android repository                                 #
# DEVICE   : Device name given in cm                                  #
# BUILD    : File to look for to initialize remote build              #
# CLEANOUT : File to look for to remove out directory                 #
# CLEANFP  : File to look for to delete frameworks/packages           #
#######################################################################

DROPBOX="/home/dmondega/Dropbox/Build"
ANDROID="/home/dmondega/android/system"
DEVICE="galaxysmtd"
BUILD="build"
CLEANOUT="cleanout"
CLEANFP="cleanfp"

#Appends to logfile
function log {
        echo "$@" >> $DROPBOX/log;
}

if [ -f $DROPBOX/$BUILD ]; then
    rm $DROPBOX/log;
    cd $ANDROID;
    log "Syncing";
    repo sync -j8;
    rm $ANDROID/out/target/product/$DEVICE/update-cm-7.1.0-GalaxyS-KANG-signed.zip
    if [ -f $DROPBOX/$CLEANOUT ]; then
	rm $DROPBOX/$CLEANOUT;
	log "Cleaning out folder";
	rm -rf out;
    fi
    if [ -f $DROPBOX/$CLEANFP ]; then
	rm $DROPBOX/$CLEANFP;
	log "Cleaning Packages and Frameworks Folder";
	rm -rf packages frameworks;
    fi
    log "Building";
    rm $DROPBOX/build-log;
    ./build.sh galaxysmtd kernel &> $DROPBOX/build-log;	
    if [ -f $ANDROID/out/target/product/$DEVICE/update-cm-7.1.0-GalaxyS-KANG-signed.zip ]; then
	rm $DROPBOX/update.zip;
	log "Build Successful";
	rm $DROPBOX/build;
    else
        log "Build failed";
    fi
    log "Copying File";
    cp $ANDROID/out/target/product/$DEVICE/update-cm*.zip $DROPBOX/update.zip;
    log "Syncing Dropbox";
fi
