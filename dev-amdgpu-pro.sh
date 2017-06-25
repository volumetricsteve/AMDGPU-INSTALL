#!/bin/bash
#set -x
clear
AMDGPU_PRO_ROOT_DIRECTORY="$(pwd)"

if [ "$1" = "uninstall" ] || [ "$1" = "-uninstall" ]
then
	echo "this will rip and tear until it is done"
	echo "building uninstall manifest"
	uninstall_root="$AMDGPU_PRO_ROOT_DIRECTORY/amdgpu-pro-installdir/DRIVER"
	if [ -d $uninstall_root ]
	then
		echo "ready to build manifest"
	else
		echo "missing install files :: please run installer before uninstalling"
		exit
	fi
	if [ -f $uninstall_root/manifest.db ]
	then
		rm $uninstall_root/manifest.db
	fi
	if [ -f $uninstall_root/sort.db ]
	then
		rm $uninstall_root/sort.db
	fi
	manifest=$(du -a $uninstall_root | cut -f2 | awk '{ print $1 }')
	echo "gathering md5sums"
	for each in $manifest
do
        target_dir="${each}"
        md5sum $target_dir >> $uninstall_root/manifest.db 2>&1
done
	cat $uninstall_root/manifest.db | sort > $uninstall_root/sort.db 2>&1
	mv $uninstall_root/sort.db $uninstall_root/manifest.db
        echo "uninstalling"
        exit
fi

#you need a way to build a manifest based on what's installed locally, probably 
#manifest=$(du -a /etc | cut -f2 | awk '{ print $1 }')
#manifest=$(du -a $uninstall_root | cut -f2 | awk '{ print $1 }')
#somewhere you need to do a line by line comparion of what comes out of the other manifest,
#ideally, if you start your directories on 'DRIVER' pseudo-locally and do etc,usr, lib. and 
#whatever locally, it should be easier to line up which files you're comparing
#NOTE: cat manifest.db | sed '12q;d' | cut -d ' ' -f3 to isolate the full paths of elements in manifest.db


if [ "$1" = "clean" ] || [ "$1" = "-clean" ]
then
rm -rf $AMDGPU_PRO_ROOT_DIRECTORY/amdgpu-pro-installdir
exit
fi
AMDGPU_PRO_TAR_NAME="$(ls -1 | grep -i .tar.xz | grep -i amdgpu)"
echo "TAR name:"$AMDGPU_PRO_TAR_NAME
echo "Root tar Directory:"$AMDGPU_PRO_ROOT_DIRECTORY
echo ""
echo "#####################################"
echo "#    AMDGPU-PRO X86/64 INSTALLER    #"
echo "# THIS IS PROVIDED WITHOUT WARRANTY #"
echo "# ARE YOU SURE YOU WANT TO PROCEED? #"
echo "#     ENTER I AGREE TO CONTINUE     #"
echo "#####################################"
read -p "             " opt
    case ${opt} in
        "I AGREE")
            echo "CONTINUTING"
            ;;
        "QUIT")
            echo "QUITTING"
            exit
            ;;
        *) echo "invalid option"
            exit
            ;;
    esac
if [ -d amdgpu-pro-installdir ]
    then
    echo "PREVIOUS INSTALL CACHE FOUND.  PURGE BEFORE NEW INSTALL?"
    options=("PURGE" "IGNORE")
        select opt in "${options[@]}"
        do
            case $opt in
                "PURGE")
                echo "CLEARING PREVIOUS INSTALL FILES"
                rm -rf $AMDGPU_PRO_ROOT_DIRECTORY/amdgpu-pro-installdir
                break
                ;;
                "IGNORE")
                break
                ;;
                *)
                echo "ERROR"
                exit
                ;;
            esac
        done
fi
echo "EXTRACTING AMD DEBIAN PACKAGE"
mkdir $AMDGPU_PRO_ROOT_DIRECTORY/amdgpu-pro-installdir
tar -xf $AMDGPU_PRO_ROOT_DIRECTORY/$AMDGPU_PRO_TAR_NAME --strip 1 -C $AMDGPU_PRO_ROOT_DIRECTORY/amdgpu-pro-installdir/
echo "changing working directory to: "$AMDGPU_PRO_ROOT_DIRECTORY"/amdgpu-pro-installdir/"
AMDGPU_PRO_BASE_DIRECTORY=${AMDGPU_PRO_ROOT_DIRECTORY}/amdgpu-pro-installdir
cd $AMDGPU_PRO_BASE_DIRECTORY
rm $AMDGPU_PRO_BASE_DIRECTORY/amdgpu-pro-install $AMDGPU_PRO_BASE_DIRECTORY/Packages $AMDGPU_PRO_BASE_DIRECTORY/Release
if [ "$1" = "compute" ] 
	then
	echo "INSTALLING 64-BIT COMPUTE DRIVERS ONLY"
	mkdir $AMDGPU_PRO_BASE_DIRECTORY/tmp
	mv clinfo-amdgpu-pro_17.10-429170_amd64.deb $AMDGPU_PRO_BASE_DIRECTORY/tmp/
	mv opencl-amdgpu-pro-icd_17.10-429170_amd64.deb $AMDGPU_PRO_BASE_DIRECTORY/tmp/
	mv amdgpu-pro-dkms_17.10-429170_all.deb $AMDGPU_PRO_BASE_DIRECTORY/tmp/
	mv libdrm2-amdgpu-pro_2.4.70-429170_amd64.deb $AMDGPU_PRO_BASE_DIRECTORY/tmp/
	mv libdrm-amdgpu-pro-amdgpu1_2.4.70-429170_amd64.deb $AMDGPU_PRO_BASE_DIRECTORY/tmp/
		rm *.deb
	mv $AMDGPU_PRO_BASE_DIRECTORY/tmp/* $AMDGPU_PRO_BASE_DIRECTORY/
	rmdir $AMDGPU_PRO_BASE_DIRECTORY/tmp/
		if [ $(ls $AMDGPU_PRO_BASE_DIRECTORY/ | wc -l) = 5 ]
			then
			echo "CORRECT NUMBER OF MODULES REMAINING :: PROCEEDING"
		else
			echo "INCORRECT NUMBER OF MODULES FOUND :: EXITING"
			exit
		fi
fi
AMDGPU_PRO_DEBLIST="$(ls -1 | grep -i .deb)"
for each in $AMDGPU_PRO_DEBLIST
do
        AMDGPU_PRO_DIRtoken="${each//.deb/ }"
        AMDGPU_PRO_DEBtoken="${each}"
        mkdir $AMDGPU_PRO_DIRtoken
        mv $AMDGPU_PRO_DEBtoken $AMDGPU_PRO_DIRtoken
        cd $AMDGPU_PRO_DIRtoken
        ar vx $AMDGPU_PRO_DEBtoken > /dev/null
        tar -xf data.tar.xz > /dev/null
        rm data.tar.xz
        rm debian-binary
        rm control.tar.gz
        rm $AMDGPU_PRO_DEBtoken
cd ..
done
AMDGPU_PRO_DIRLIST="$(ls -1)"
for each in $AMDGPU_PRO_DIRLIST
do
        AMDGPU_PRO_DIRtoken="${each}"
        cd $AMDGPU_PRO_DIRtoken
        rsync -av ./ ../ > /dev/null
        cd $AMDGPU_PRO_ROOT_DIRECTORY/amdgpu-pro-installdir
done
mkdir $AMDGPU_PRO_BASE_DIRECTORY/DRIVER
mv $AMDGPU_PRO_BASE_DIRECTORY/etc DRIVER/
mv $AMDGPU_PRO_BASE_DIRECTORY/usr DRIVER/
mv $AMDGPU_PRO_BASE_DIRECTORY/lib DRIVER/
mv $AMDGPU_PRO_BASE_DIRECTORY/opt DRIVER/
cd DRIVER
printf "\n"
echo "MERGING ETC"
#rsync -av etc/ /etc/ > /dev/null
echo "MERGING LIB"
#rsync -av lib/ /lib/ > /dev/null
echo "MERGING USR"
#rsync -av usr/ /usr/ > /dev/null
echo "MERGING OPT"
#rsync -av opt/ /opt/ > /dev/null
echo "REPLACING ICD"
#cp $AMDGPU_PRO_BASE_DIRECTORY/DRIVER/opt/amdgpu-pro/lib/x86_64-linux-gnu/* /lib > /dev/null
echo "DONE"
