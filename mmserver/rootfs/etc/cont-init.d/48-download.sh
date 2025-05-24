#!/usr/bin/with-contenv bashio
# ==============================================================================

CFG="/config"

# Download if required
if [ ! -r $DAEMON_SOFTWARE_INSTALLER -a ! -r $DAEMON_STARTUP ];then
   bashio::log.info "Download $DAEMON_SOFTWARE_URL"
   apt-get update
   apt-get install --no-install-recommends wget
   wget -O $DAEMON_SOFTWARE_INSTALLER $DAEMON_SOFTWARE_URL
fi

