FROM mediawiki:lts

MAINTAINER Ann Arbor District Library <github@aadl.org>

RUN set -x; \
    apt-get update && \
    apt-get install -y libldap2-dev \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

RUN set -x; \
    mkdir -p /usr/src/mediawiki/extensions

RUN EXT_DL_URL="https://extdist.wmflabs.org/dist/extensions/LdapAuthentication-REL1_27-b0dba33.tar.gz"; \
    EXT_TARBALL="ldapauth_ext.tar.gz"; \
    set -x; \
    curl -fSL "$EXT_DL_URL" -o "$EXT_TARBALL" && \
    tar -xf "$EXT_TARBALL" -C /usr/src/mediawiki/extensions && \
    rm "$EXT_TARBALL"

RUN set -x; \
    sed -i 's/rtrim/trim/' /usr/src/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php

RUN set -x; \
    echo "TLS_REQCERT     never" >> /etc/ldap/ldap.conf
