#!/usr/bin/with-contenv bashio
# ==============================================================================

CFG="/config"
cp -uv /opt/mip/mmserver/share/MusicMagicMixer/server/index.html $DAEMON_INSTALL_DIR/MusicIP/MusicMagicMixer/server/

cd ${CFG}

[ ! -x MusicMagic ] && ln -vs .MusicMagic MusicMagic

exit 0
