#!/bin/bash

sed -i 's/%%NGX_LOGLEVEL%%/'"$NGX_LOGLEVEL"'/g' /opt/nginx/conf/nginx.conf && \
sed -i 's/%%NGX_UPSTREAM_NAME%%/'"$NGX_UPSTREAM_NAME"'/g' /opt/nginx/conf/nginx.conf && \
sed -i 's/%%NGX_UPSTREAM_SERVER%%/'"$NGX_UPSTREAM_SERVER"'/g' /opt/nginx/conf/nginx.conf && \
sed -i 's/%%NPS_ENABLED%%/'"$NPS_ENABLED"'/g' /opt/nginx/conf/nginx.conf && \

eval "/opt/nginx/./nginx $@"