#!/bin/bash
clear
if [ "$1" = "uninstall" ]
then
        #uninstall stuff
        echo "uninstalling"
        exit
fi
AMDGPU_PRO_ROOT_DIRECTORY="$(pwd)"
AMDGPU_PRO_ROOT_DIRECTORY=${AMDGPU_PRO_ROOT_DIRECTORY}
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
if [ -d amdgpu-pro-install ]
    then
    echo "PREVIOUS INSTALL CACHE FOUND.  PURGE BEFORE NEW INSTALL?"
    options=("PURGE" "IGNORE")
        select opt in "${options[@]}"
        do
            case $opt in
                "PURGE")
                echo "CLEARING PREVIOUS INSTALL FILES"
                rm -rf $AMDGPU_PRO_ROOT_DIRECTORY/amdgpu-pro-install
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
mkdir $AMDGPU_PRO_ROOT_DIRECTORY/amdgpu-pro-install
tar -xf $AMDGPU_PRO_ROOT_DIRECTORY/$AMDGPU_PRO_TAR_NAME --strip 1 -C $AMDGPU_PRO_ROOT_DIRECTORY/amdgpu-pro-install/
echo "changing working directory to: "$AMDGPU_PRO_ROOT_DIRECTORY"/amdgpu-pro-install/"
AMDGPU_PRO_BASE_DIRECTORY=${AMDGPU_PRO_ROOT_DIRECTORY}/amdgpu-pro-install
cd $AMDGPU_PRO_BASE_DIRECTORY
rm $AMDGPU_PRO_BASE_DIRECTORY/amdgpu-pro-install $AMDGPU_PRO_BASE_DIRECTORY/Packages $AMDGPU_PRO_BASE_DIRECTORY/Release
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
        cd $AMDGPU_PRO_ROOT_DIRECTORY/amdgpu-pro-install
done
mkdir $AMDGPU_PRO_BASE_DIRECTORY/DRIVER
mv $AMDGPU_PRO_BASE_DIRECTORY/etc DRIVER/
mv $AMDGPU_PRO_BASE_DIRECTORY/usr DRIVER/
mv $AMDGPU_PRO_BASE_DIRECTORY/lib DRIVER/
mv $AMDGPU_PRO_BASE_DIRECTORY/opt DRIVER/
cd DRIVER
printf "\n"
echo "MERGING ETC"
rsync -av etc/ /etc/ > /dev/null
echo "MERGING LIB"
rsync -av lib/ /lib/ > /dev/null
echo "MERGING USR"
rsync -av usr/ /usr/ > /dev/null
echo "MERGING OPT"
rsync -av opt/ /opt/ > /dev/null