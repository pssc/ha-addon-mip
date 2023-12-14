#!/usr/bin/with-contenv bashio
# ==============================================================================

#FIXME
CFG="/config/addons_config/mmserver"

cp /opt/mip/mmserver/share/MusicMagicMixer/server/index.html $DAEMON_INSTALL_DIR/MusicIP/MusicMagicMixer/server/

exit 0
# Install if required
if [ ! -r $DAEMON_STARTUP -a -r $DAEMON_SOFTWARE_INSTALLER ];then
   bashio::log.info "install this can take some time..."
   cd $DAEMON_INSTALL_DIR
   $DAEMON_SOFTWARE_INSTALLER_COMMAND $DAEMON_SOFTWARE_INSTALLER
   if [ -r $DAEMON_STARTUP ];then
	   rm $DAEMON_SOFTWARE_INSTALLER
           # reinstall in finish
	   rm -f ${CFG}/reinstall
	   touch $DAEMON_INSTALL_DIR/ha-install
           bashio::log.info "installed"
   fi
fi

