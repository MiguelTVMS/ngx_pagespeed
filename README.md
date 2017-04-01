# ngx_pagespeed
Docker file do create and build a nginx image with ng_pagepeed module compiled together.

## Configuration

### Environment variables
You can configure the container using those encvironment variables

**NGX_LOGLEVEL**  
Set the log levevel you want to be expoded by the nginx error logs.  

**NGX_UPSTREAM_NAME**  
Set the Nginx 



### Exposed ports
Sinde the main idea of this contaier is to test ng_pagespeed in action it only exposes the por 80.
In the future we will make it work on https.

## How to use it

### As it is

To use the image as it is just start the container

```cmd
docker run -p 80:8080 jmtvms/ngx_pagespeed
```

After the container is created you can just use go to http://localhost:8080 and see it working



## Configuration

