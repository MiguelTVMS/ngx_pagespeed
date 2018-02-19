# ngx_pagespeed
Docker file do create and build a nginx image with ng_pagepeed module compiled together.

## Configuration

### Environment variables
You can configure the container using those environment variables.  
***Notice:*** The container must be started with the environment variables set correctly. Any change made on the environment variables after the container is runnig will be disconsidered.

#### Nginx settings:
The nginx environment variables start with ``NGX_``.

**NGX_LOGLEVEL** *Default:* ``debug``  
Set the log levevel you want to be expoded by the nginx error logs.  

**NGX_UPSTREAM_NAME** *Default:* ``www.google.com``  
Set the name of the nginx upstream server.  

**NGX_UPSTREAM_SERVER** *Default:* ``www.google.com:80``  
The server that will respond to the upstream.

#### Page speed module settings:
The following settings use the same names as the settings created by Google on the page speed module. The only difference is that the environment variables are all prepended with ``NPS_``.  
***Notice:*** Not all settings are available yet. We are working on that.   
For more information, visit Google's page speed module configurarion page [here](https://modpagespeed.com/doc).  

**NPS_ENABLED**  *Default:* ``on``  
Enable or disable the page speed module completely.  

We changed a lot since the original version. Now we have expoded the volume with the nginx.conf to give you more flexibility. All the environment variables were removed and now are set directly on the nginx.conf file. just map the volume _/opt/nginx/conf/_ to some folder on your machine and you can change the file freely.

```sh

docker run -it -p 8080:80 -v ~/ngx_pagespeed/conf:/opt/nginx/conf/ jmtvms/ngx_pagespeed

```

### Exposed ports
The main idea of this image is to test ngx_pagespeed in action, it only exposes the por 80(HTTP). We are working to make it work on 443(HTTPS).

## How to use it

### As it is

To use the image as it is just start the container

```sh

docker run -it -p 8080:80 jmtvms/ngx_pagespeed

```

### Set different configuration

To use this container using different configuration you can set any environment variables using the parameter ``-e "VARIABLE_NAME=value"``.

```sh

docker run -it -p 8080:80 -e "NPS_ENABLED=off" jmtvms/ngx_pagespeed

```

This will start the container but the page speed module will be disabled.

After the container is created you can just use go to ``http://localhost:8080`` and see it working.

### Exposed Volumes

#### /opt/nginx/conf/

The volume where the nginx.conf file is located. just remember to reload the configuration file everytime you change something.

#### /opt/nginx/html/

You can add some static files in this folder to be served by the nginx server.

#### /var/nginx/logs/

Most of the logs are shown on the container console but you can have access to the folder directly if you configure any other log on the configuration file.
