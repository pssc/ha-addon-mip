#!/usr/bin/with-contenv bashio
# ==============================================================================
declare port
declare certfile
declare dns_host
declare ingress_interface
declare ingress_port
declare ingress_entry
declare keyfile

port=$(bashio::addon.port 80)
ingress_entry=$(bashio::addon.ingress_entry)
if bashio::var.has_value "${port}"; then
    bashio::config.require.ssl
    bashio::log.info "Direct"

    if bashio::config.true 'ssl'; then
        bashio::log.info "SSL"
        certfile=$(bashio::config 'certfile')
        keyfile=$(bashio::config 'keyfile')

        mv /etc/nginx/servers/direct-ssl.disabled /etc/nginx/servers/direct.conf
        sed -i "s#%%certfile%%#${certfile}#g" /etc/nginx/servers/direct.conf
        sed -i "s#%%keyfile%%#${keyfile}#g" /etc/nginx/servers/direct.conf

    else
        bashio::log.info "Unencryped"
        mv /etc/nginx/servers/direct.disabled /etc/nginx/servers/direct.conf
    fi

    sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/nginx/servers/direct.conf
fi


bashio::log.info "Ingress"
ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
sed -i "s/%%port%%/${ingress_port}/g" /etc/nginx/servers/ingress.conf
sed -i "s/%%interface%%/${ingress_interface}/g" /etc/nginx/servers/ingress.conf
sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/nginx/servers/ingress.conf

bashio::log.info "DNS"
# needed?
dns_host=$(bashio::dns.host)
bashio::log.info "DNS ${dns_host}"
sed -i "s/%%dns_host%%/${dns_host}/g" /etc/nginx/includes/resolver.conf
