#!/bin/bash
clear
if [ "$1" = "uninstall" ]
then
        #uninstall stuff
        echo "uninstalling"
        exit
fi
spin='-\|/'
i=0
x=1
v=2
e=3
rotate ()
{
i=$(( (i+1) %4 ))
x=$(( (x+1) %4 ))
v=$(( (v+1) %4 ))
e=$(( (e+1) %4 ))
printf "\r${spin:$i:1} ${spin:$x:1} ${spin:$v:1} ${spin:$e:1}"
}
AMDGPU_PRO_ROOT_DIRECTORY="$(pwd)"
AMDGPU_PRO_ROOT_DIRECTORY=${AMDGPU_PRO_ROOT_DIRECTORY}
AMDGPU_PRO_TAR_NAME="$(ls -1 | grep -i *.tar* | grep -i amdgpu-pro)"
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
if [ -d amdgpu-pro-driver ]
    then
    echo "PREVIOUS INSTALL CACHE FOUND.  PURGE BEFORE NEW INSTALL?"
    options=("PURGE" "IGNORE")
        select opt in "${options[@]}"
        do
            case $opt in
                "PURGE")
                echo "CLEARING PREVIOUS INSTALL FILES"
                rm -rf $AMDGPU_PRO_ROOT_DIRECTORY/amdgpu-pro-driver
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
tar -xf $AMDGPU_PRO_ROOT_DIRECTORY/$AMDGPU_PRO_TAR_NAME
echo "changing working directory to: "$AMDGPU_PRO_ROOT_DIRECTORY"/amdgpu-pro-driver/"
AMDGPU_PRO_BASE_DIRECTORY=$AMDGPU_PRO_ROOT_DIRECTORY"/amdgpu-pro-driver/"
cd $AMDGPU_PRO_BASE_DIRECTORY
rm $AMDGPU_PRO_BASE_DIRECTORY/amdgpu-pro-install $AMDGPU_PRO_BASE_DIRECTORY/Packages.gz
AMDGPU_PRO_DEBLIST="$(ls -1 | grep -i .deb)"
for each in $AMDGPU_PRO_DEBLIST
do
        AMDGPU_PRO_DIRtoken="${each//.deb/ }"
        AMDGPU_PRO_DEBtoken="${each}"
        mkdir $AMDGPU_PRO_DIRtoken
        mv $AMDGPU_PRO_DEBtoken $AMDGPU_PRO_DIRtoken
                rotate
        cd $AMDGPU_PRO_DIRtoken
                rotate
        ar vx $AMDGPU_PRO_DEBtoken > /dev/null
                rotate
        tar -xf data.tar.xz > /dev/null
                rotate
        rm data.tar.xz
        rm debian-binary
        rm control.tar.gz
        rm $AMDGPU_PRO_DEBtoken
cd ..
        rotate
done
AMDGPU_PRO_DIRLIST="$(ls -1)"
for each in $AMDGPU_PRO_DIRLIST
do
        AMDGPU_PRO_DIRtoken="${each}"
        cd $AMDGPU_PRO_DIRtoken
        rsync -av ./ ../ > /dev/null
        cd ..
        rotate
done
mkdir $AMDGPU_PRO_BASE_DIRECTORY/DRIVER
mv $AMDGPU_PRO_BASE_DIRECTORY/etc DRIVER/
mv $AMDGPU_PRO_BASE_DIRECTORY/usr DRIVER/
mv $AMDGPU_PRO_BASE_DIRECTORY/lib DRIVER/
find $AMDGPU_PRO_BASE_DIRECTORY"DRIVER" -type f -print0 | xargs -0 md5sum > $AMDGPU_PRO_BASE_DIRECTORY"DRIVER/AMDGPU_PRO_manifest.md5"
cd DRIVER
printf "\n"

md5="${cat $AMDGPU_PRO_BASE_DIRECTORY"DRIVER"/AMDGPU_PRO_manifest.md5 | cut -d ' ' -f 1}"
echo $md5

echo "MERGING ETC"
rsync -av etc/ /etc/ > /dev/null
echo "MERGING LIB"
rsync -av lib/ /lib/ > /dev/null
echo "MERGING USR"
rsync -av usr/ /usr/ > /dev/null
