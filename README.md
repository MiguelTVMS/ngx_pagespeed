# ngx_pagespeed
Docker file do create and build a nginx image with ng_pagepeed module compiled together.

## Configuration

### Environment variables
You can configure the container using those encvironment variables

#### Nginx settings:

**NGX_LOGLEVEL**  
Set the log levevel you want to be expoded by the nginx error logs.  
***Default:*** www.google.com

**NGX_UPSTREAM_NAME**  
Set the name of the nginx upstream server.  
***Default:*** www.google.com

**NGX_UPSTREAM_NAME**  
The server that will respond for the upstream.  
***Default:*** www.google.com:80

#### Page speed module settings:
The following settins try to use the same names as the settings created by Google on the module. The only diference is that the environment variables are all prepended with "NPS_".

For more information see Google's page speed module configurarion page [here](https://modpagespeed.com/doc).

**NPS_ENABLED**  ***Default:*** ``on``  
Enable or disable the page speed module.  

**NPS_LOWERCASEHTMLNAMES** ***Default:*** ``on``  
Enable or disable the page speed module.  


**NPS_ENABLEFILTERS** ***Default:*** ``rewrite_javascript,move_css_to_head,rewrite_css,combine_css,combine_javascript,collapse_whitespace,dedup_inlined_images,elide_attributes``    
Filters enabled on the page speed module. This variable must have at least one filter or the nginx configuration will break. If you want to disable the module use the NPS_ENABLED variable. for more information about the options on this variable check out the documentation page [here](https://modpagespeed.com/doc/).   
 

**NPS_RESPECTVARY** ***Default:*** ``off``   
In order to maximize the number of resources that PageSpeed can rewrite, by default the module does not respect Vary: User-Agent and other Vary headers on resource files, such as JavaScript and css files. By disregarding the Vary headers, PageSpeed is able to keep the size of the cache down. PageSpeed will always respect Vary: Accept-Encoding, regardless of this setting. PageSpeed will also always respect Vary headers on HTML files, regardless of this setting. 
If a site has resources that legitimately vary on User-Agent, or on some other attribute, then in order to preserve that behavior, you must set ``NPS_RESPECTVARY`` on your environment variables.  


**NPS_DISABLEREWRITEONNOTRANSFORM**  ***Default:*** ``off``   
By default, PageSpeed does not rewrite resources that have ``Cache-Control: no-transform``  set in the Response Header. This is true for all types of resources, such as JavaScript, images, CSS etc. By respecting ``Cache-Control: no-transform`` headers, PageSpeed cannot optimize resources that could otherwise be rewritten. 
To optimize resources irrespective of ``Cache-Control: no-transform`` headers, you must set ``NPS_DISABLEREWRITEONNOTRANSFORM on`` to your environment variables.


**NPS_LOWERCASEHTMLNAMES**



ENV NPS_ENABLED=on
ENV NPS_LOWERCASEHTMLNAMES=on
ENV NPS_ENABLEFILTERS=rewrite_javascript,move_css_to_head,rewrite_css,combine_css,combine_javascript,collapse_whitespace,dedup_inlined_images,elide_attributes
ENV NPS_RESPECTVARY off
ENV NPS_DISABLEREWRITEONNOTRANSFORM on
ENV NPS_MODIFYCACHINGHEADERS on
ENV NPS_XHEADERVALUE "Powered By jmtvms/ngx_pagespeed"

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

