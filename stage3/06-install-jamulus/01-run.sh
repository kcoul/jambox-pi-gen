# Install desktop shortcuts.
mkdir -p ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/lxsession/LXDE-pi
cp files/autostart ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/lxsession/LXDE-pi/autostart
cp files/jackdrc ${ROOTFS_DIR}/etc/jackdrc
chmod +x ${ROOTFS_DIR}/etc/jackdrc

mkdir -p ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/Desktop
cp files/Desktop/*.desktop ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/Desktop/

cp files/jamulus_start.sh ${ROOTFS_DIR}/usr/local/bin/
chmod +x ${ROOTFS_DIR}/usr/local/bin/jamulus_start.sh

cp files/jambox_start.sh ${ROOTFS_DIR}/usr/local/bin/
chmod +x ${ROOTFS_DIR}/usr/local/bin/jambox_start.sh

mkdir -p ${ROOTFS_DIR}/boot/payload/home/${FIRST_USER_NAME}/.config/Jamulus
mkdir -p ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/Jamulus

# allow custom build version by defining:
#   export CUSTOM_VERSION=<custom_version_name>
# and placing customized files in directory:
#   stage3/06-install-jamulus/files/${CUSTOM_VERSION}/
# customized files may include:
#   jamulus_start.conf
#   Jamulus.ini
#   README.md

if [[ -n "$CUSTOM_VERSION" ]]; then
  if [[ -f files/${CUSTOM_VERSION}/jamulus_start.conf ]]; then
    cp files/${CUSTOM_VERSION}/jamulus_start.conf ${ROOTFS_DIR}/boot/payload/home/${FIRST_USER_NAME}/.config/Jamulus/
    cp files/${CUSTOM_VERSION}/jamulus_start.conf ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/Jamulus/
  else
    cp files/jamulus_start.conf ${ROOTFS_DIR}/boot/payload/home/${FIRST_USER_NAME}/.config/Jamulus/
    cp files/jamulus_start.conf ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/Jamulus/
  fi
  if [[ -f files/${CUSTOM_VERSION}/Jamulus.ini ]]; then
    cp files/${CUSTOM_VERSION}/Jamulus.ini ${ROOTFS_DIR}/boot/payload/home/${FIRST_USER_NAME}/.config/Jamulus/
    cp files/${CUSTOM_VERSION}/Jamulus.ini ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/Jamulus/
  else
    cp files/Jamulus.ini ${ROOTFS_DIR}/boot/payload/home/${FIRST_USER_NAME}/.config/Jamulus/
    cp files/Jamulus.ini ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/Jamulus/
  fi
  if [[ -f files/${CUSTOM_VERSION}/README.md ]]; then 
    cp files/${CUSTOM_VERSION}/README.md ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/
  fi
  # if any custom version .gif files exist, copy them to /usr/local/share/
  if [[ "`echo files/${CUSTOM_VERSION}/*.gif`" != "files/${CUSTOM_VERSION}/*.gif" ]]; then
    cp files/${CUSTOM_VERSION}/*.gif ${ROOTFS_DIR}/usr/local/share/
  fi
  if [[ "`echo files/${CUSTOM_VERSION}/*.png`" != "files/${CUSTOM_VERSION}/*.png" ]]; then
    cp files/${CUSTOM_VERSION}/*.png ${ROOTFS_DIR}/usr/local/share/
  fi
else
  cp files/jamulus_start.conf ${ROOTFS_DIR}/boot/payload/home/${FIRST_USER_NAME}/.config/Jamulus/
  cp files/jamulus_start.conf ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/Jamulus/
  cp files/Jamulus.ini ${ROOTFS_DIR}/boot/payload/home/${FIRST_USER_NAME}/.config/Jamulus/
  cp files/Jamulus.ini ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/Jamulus/
fi

# install jamulus-server files (binary is same as jamulus client)
cp files/jamulus-server.service ${ROOTFS_DIR}/usr/lib/systemd/system/
cp files/jamulus-server.conf ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/Jamulus/
mkdir -p ${ROOTFS_DIR}/var/recordings

on_chroot << EOF
	chown ${FIRST_USER_NAME} /var/recordings
        chgrp audio /var/recordings
EOF
