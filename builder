DROPBOX="/home/dmondega/Dropbox/Build"
ANDROID="/home/dmondega/android/system"
if [ -f $DROPBOX/build ]; then
    rm $DROPBOX/log;
    cd $ANDROID;
    echo "Syncing" >> $DROPBOX/log && sync;
    repo sync -j8;
    rm $ANDROID/out/target/product/galaxysmtd/update-cm-7.1.0-GalaxyS-KANG-signed.zip
    if [ -f $DROPBOX/cleanout ]; then
	rm $DROPBOX/cleanout;
	echo "Cleaning out folder" >> $DROPBOX/log;
	rm -rf out;
    fi
    if [ -f $DROPBOX/cleanfp ]; then
	rm $DROPBOX/cleanfp;
	echo "Cleaning Packages and Frameworks Folder" >> $DROPBOX/log;
	rm -rf packages frameworks;
    fi
    echo "Building" >> $DROPBOX/log;
    rm $DROPBOX/build-log;
    ./build.sh galaxysmtd kernel &> $DROPBOX/build-log;	
    if [ -f $ANDROID/out/target/product/galaxysmtd/update-cm-7.1.0-GalaxyS-KANG-signed.zip ]; then
	rm $DROPBOX/update.zip;
	echo "Build Successful" >> $DROPBOX/log;
    else
        echo "Build failed" >> $DROPBOX/log;
    fi
    echo "Copying File" >> $DROPBOX/log;
    cp $ANDROID/out/target/product/galaxysmtd/update-cm-7.1.0-GalaxyS-KANG-signed.zip $DROPBOX/build/;
    echo "Syncing Dropbox" >> $DROPBOX/log;
fi
