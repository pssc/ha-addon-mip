#!/usr/bin/with-contenv bashio
# ==============================================================================

#echo -n ${HAA_NAME:-$(hostname -s|sed 's/.*-//')} >/run/s6/container_environment/HAA_NAME

getent passwd ${HA_USER}

exit 0
