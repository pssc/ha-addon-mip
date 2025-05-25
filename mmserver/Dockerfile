ARG BUILD_FROM=hassioaddons/debian-base:latest
FROM ${BUILD_FROM}
ARG target_uid=1000
ARG target_gid=1000
ARG url="https://www.spicefly.com/files/mp/MusicMixer_x86_1.8.tgz"
ARG debug=false

ARG BUILD_ARCH

ENV S6_SERVICES_GRACETIME 119000
# Set for package install
ENV DEBIAN_FRONTEND "noninteractive" 
# TZ config at runtime
ENV DISABLE_HA_AUTHENTICATION true

#FIXME non-root user... with homedir 
#db?
#ini file?

ENV HA_USER "mmserver"
ENV HA_GROUP "mmserver"
ENV HA_USER_UID "$target_uid"
ENV HA_USER_GID "$target_gid"
ENV DAEMON_OPTIONS=" "
ENV DAEMON_EXTRA_OPTIONS=" "
ENV DAEMON_APP_DIR="/config"
ENV DAEMON_INSTALL_DIR="/data/mip/install"
ENV DAEMON_SOFTWARE_URL=$url
ENV DAEMON_SOFTWARE_DOWNLOAD_DIR="/data/mip/download"
ENV DAEMON_SOFTWARE_INSTALLER_COMMAND "tar -xzf"
ENV DAEMON_STARTUP=$DAEMON_INSTALL_DIR/MusicIP/MusicMagicMixer/MusicMagicServer
ENV MUSICHOME=$DAEMON_INSTALL_DIR/MusicIP/MusicMagicMixer
ENV DAEMON_SOFTWARE_INSTALLER="${DAEMON_SOFTWARE_DOWNLOAD_DIR}/MusicMixer_x86_1.8.tgz"
ENV DAEMON="su - $HA_USER -s /bin/sh -c /opt/mip/mmserver/bin/start"
#su - $USER -c $MUSICHOME"MusicMagicServer start  & > /dev/null"


#Download to /tmp after testing.
ENV HA_DIRS="/data/music $DAEMON_SOFTWARE_DOWNLOAD_DIR $DAEMON_APP_DIR $DAEMON_INSTALL_DIR"
ENV DEBUG=$debug

COPY rootfs/ /

RUN apt-get update && \
	apt-get -y install --no-install-recommends \
		nfs-common \
		udev \
		lvm2 \
		patch \
                davfs2 \
		sshfs \
		tzdata 

# App dep.....
RUN if [[ "${BUILD_ARCH}" = "amd64" ]];then apt-get -y install libc6-i386 ;fi


RUN if [[ ! -z "${debug}" ]];then apt-get -y install vim less procps strace;fi

# add us a user....
# music.predixis.com

# FixME shared root?
# links appdir from $HOME/.bliss
# adduser
#RUN ln -s ${DAEMON_APP_DIR}  /$(getent passwd ${HA_USER} | cut -d : -f 6)/.bliss
#RUN adduser --debug --verbose --system --disabled-password --disabled-login --home ${DAEMON_APP_DIR} --shell /sbin/nologin --group ${HA_USER}
RUN adduser --debug --verbose --system --disabled-password --disabled-login --home ${DAEMON_APP_DIR} --group ${HA_USER}
# Fix Perms?


# Nginx Ingress support
RUN apt-get install -y --no-install-recommends \
        libnginx-mod-http-lua \
        luarocks \
        nginx \
        mosquitto-clients \
    && luarocks install lua-resty-http 0.15-0 \
    && rm -r /etc/nginx
COPY rootfs-ingress/ /

#COPY patch /sources/
#RUN for i in /sources/*.patch;do patch -d / -p1 -i $i;done

#Cleanup
RUN if [ -z "${debug}" -o "${debug}" = "false" ];then apt-get -y remove \
           git \
           && \
	apt-get clean -y && \
	apt-get -y autoremove && \
        rm -fr /sources ;fi

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="mmserver" \
    io.hass.description="MusicIP MusicMagicMixer Server Installer" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Phillip Camp <phillip.camp+ha<removeme>@gmail.com>" \
    org.label-schema.description="MusicIP MusicMagicMixer Server Installer" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="mmserver" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.usage="https://github.com/pssc/ha-addon-mip/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/pssc/ha-addon-mip/mmserver" \
    org.label-schema.vendor="pssc"
#    org.label-schema.url="https://community.home-assistant.io/t/home-assistant-community-add-on-portainer/68836?u=pssc"
