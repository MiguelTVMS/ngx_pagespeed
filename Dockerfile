FROM debian:jessie

LABEL maintainer "João Miguel <joao@miguel.ms>"
LABEL github "https://github.com/jmtvms/ngx_pagespeed"
LABEL dockerhub "https://hub.docker.com/r/jmtvms/ngx_pagespeed/"

RUN apt-get -y update && apt-get install -y \
 wget \
 build-essential \
 libpcre3-dev \
 zlib1g-dev

ENV NGINX_VERSION=1.11.12
ENV NPS_VERSION=1.11.33.5
ENV PSOL_VERSION=1.11.33.4
ENV SUBS_VERSION=0.6.4
ENV OPENSSL_VERSION=1.1.0e

RUN useradd -r -s /usr/sbin/nologin nginx

RUN ["mkdir","/usr/nginx_source/"]
WORKDIR "/usr/nginx_source/"

# Preparing Nginx
RUN wget -qO nginx.tar.gz http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz
RUN tar -xvzf nginx.tar.gz

# Preparing ngx_http_substitutions_filter_module
RUN wget -qO ngx_http_substitutions_filter_module.tar.gz https://github.com/yaoweibin/ngx_http_substitutions_filter_module/archive/v$SUBS_VERSION.tar.gz
RUN tar -xzvf ngx_http_substitutions_filter_module.tar.gz

# Preparing OpenSSL
RUN wget -qO openssl.tar.gz https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz
RUN tar -xvzf openssl.tar.gz
RUN ls

# Preparing PageSpeed
RUN wget -O ngpagespeed.tar.gz https://github.com/pagespeed/ngx_pagespeed/archive/latest-stable.tar.gz
RUN tar -xvzf ngpagespeed.tar.gz
WORKDIR "/usr/nginx_source/ngx_pagespeed-latest-stable/"
RUN wget https://dl.google.com/dl/page-speed/psol/$PSOL_VERSION.tar.gz
RUN tar -xzvf $PSOL_VERSION.tar.gz

# Building Nginx
WORKDIR "/usr/nginx_source/nginx-$NGINX_VERSION/"

RUN ./configure \
 --add-module=/usr/nginx_source/ngx_pagespeed-latest-stable \
 --add-module=/usr/nginx_source/ngx_http_substitutions_filter_module-$SUBS_VERSION \
 --with-openssl=/usr/nginx_source/openssl-$OPENSSL_VERSION \
 --with-http_ssl_module  \
 --user=nginx  \
 --group=nginx

RUN make
RUN make install

RUN rm -rf /usr/nginx_source

RUN apt-get purge -y \
 wget \
 build-essential \
 libpcre3-dev \
 zlib1g-dev \
 && apt-get autoremove -y

ENV NGX_LOGLEVEL=debug
ENV NGX_UPSTREAM_NAME=www.google.com
ENV NGX_UPSTREAM_SERVER=www.google.com:80

ENV NPS_ENABLED=on
ENV NPS_LOWERCASEHTMLNAMES=on
ENV NPS_ENABLEFILTERS=rewrite_javascript,move_css_to_head,rewrite_css,combine_css,combine_javascript,collapse_whitespace,dedup_inlined_images,elide_attributes
ENV NPS_RESPECTVARY off
ENV NPS_DISABLEREWRITEONNOTRANSFORM on
ENV NPS_MODIFYCACHINGHEADERS on
ENV NPS_XHEADERVALUE "Powered By jmtvms/ngx_pagespeed"

COPY content/nginx.conf /usr/local/nginx/conf/
COPY content/robots.txt /usr/local/nginx/html/

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /usr/local/nginx/logs/access.log
RUN ln -sf /dev/stderr /usr/local/nginx/logs/error.log

WORKDIR /usr/local/nginx/sbin/

ENTRYPOINT \
sed -i 's/%%NGX_LOGLEVEL%%/'"$NGX_LOGLEVEL"'/g' /usr/local/nginx/conf/nginx.conf && \
sed -i 's/%%NGX_UPSTREAM_NAME%%/'"$NGX_UPSTREAM_NAME"'/g' /usr/local/nginx/conf/nginx.conf && \
sed -i 's/%%NGX_UPSTREAM_SERVER%%/'"$NGX_UPSTREAM_SERVER"'/g' /usr/local/nginx/conf/nginx.conf && \
sed -i 's/%%NPS_ENABLED%%/'"$NPS_ENABLED"'/g' /usr/local/nginx/conf/nginx.conf && \
sed -i 's/%%NPS_LOWERCASEHTMLNAMES%%/'"$NPS_LOWERCASEHTMLNAMES"'/g' /usr/local/nginx/conf/nginx.conf && \
sed -i 's/%%NPS_ENABLEFILTERS%%/'"$NPS_ENABLEFILTERS"'/g' /usr/local/nginx/conf/nginx.conf && \
sed -i 's/%%NPS_RESPECTVARY%%/'"$NPS_RESPECTVARY"'/g' /usr/local/nginx/conf/nginx.conf && \
sed -i 's/%%NPS_DISABLEREWRITEONNOTRANSFORM%%/'"$NPS_DISABLEREWRITEONNOTRANSFORM"'/g' /usr/local/nginx/conf/nginx.conf && \
sed -i 's/%%NPS_MODIFYCACHINGHEADERS%%/'"$NPS_MODIFYCACHINGHEADERS"'/g' /usr/local/nginx/conf/nginx.conf && \
#cat /usr/local/nginx/conf/nginx.conf && \
/usr/local/nginx/sbin/./nginx -g 'daemon off;';

CMD [""]

EXPOSE 80
EXPOSE 443