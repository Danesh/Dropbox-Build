######################################################################
# DROPBOX : Folder on dropbox to use to update status and update.zip #
# ANDROID : Local android repository                                 #
# DEVICE  : Device name given in cm                                  #
######################################################################

DROPBOX="/home/dmondega/Dropbox/Build"
ANDROID="/home/dmondega/android/system"
DEVICE="galaxysmtd"

#Appends to logfile
function log {
        echo "$@" >> $DROPBOX/log;
}

if [ -f $DROPBOX/build ]; then
    rm $DROPBOX/log;
    cd $ANDROID;
    log "Syncing";
    repo sync -j8;
    rm $ANDROID/out/target/product/$DEVICE/update-cm-7.1.0-GalaxyS-KANG-signed.zip
    if [ -f $DROPBOX/cleanout ]; then
	rm $DROPBOX/cleanout;
	log "Cleaning out folder";
	rm -rf out;
    fi
    if [ -f $DROPBOX/cleanfp ]; then
	rm $DROPBOX/cleanfp;
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
