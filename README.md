# ngx_pagespeed
Docker file do create and build a nginx image with ng_pagepeed module compiled together.

## Configuration

### Environment variables
You can configure the container using those encvironment variables.  
***Notice:*** The container must be started with the environment variables set correctly. Any change made on the environment variables after the container is runnig will be discodired.

#### Nginx settings:
The nginx environment variables start with ``NGX_``.

**NGX_LOGLEVEL** *Default:* ``debug``  
Set the log levevel you want to be expoded by the nginx error logs.  

**NGX_UPSTREAM_NAME** *Default:* ``www.google.com``  
Set the name of the nginx upstream server.  

**NGX_UPSTREAM_NAME** *Default:* ``www.google.com:80``  
The server that will respond for the upstream.

#### Page speed module settings:
The following settins try to use the same names as the settings created by Google on the module. The only diference is that the environment variables are all prepended with ``NPS_``.

For more information see Google's page speed module configurarion page [here](https://modpagespeed.com/doc).

**NPS_ENABLED**  *Default:* ``on``  
Enable or disable the page speed module.  

**NPS_LOWERCASEHTMLNAMES** *Default:* ``on``  
HTML is case-insensitive, whereas XML and XHTML are not. Web performance Best Practices suggest using lowercase keywords, and PageSpeed can safely make that transformation in HTML documents. 
In general, PageSpeed knows whether a document is HTML or not via Content-Type tags in HTTP headers, and DOCTYPE. However, many web sites have Content-Type: text/html for resources that are actually XML documents. 
If PageSpeed lowercases keywords in XML pages, it can break the consumers of such pages, such as Flash. To be conservative and avoid breaking such pages, PageSpeed does not lowercase HTML element and attribute names by default. However, you can sometimes achieve a modest improvement in the size of compressed HTML by enabling this feature with settings the environment variable ``NPS_LOWERCASEHTMLNAMES on``.  

**NPS_ENABLEFILTERS** *Default:* ``rewrite_javascript,move_css_to_head,rewrite_css,combine_css,combine_javascript,collapse_whitespace,dedup_inlined_images,elide_attributes``    
Filters enabled on the page speed module. This variable must have at least one filter or the nginx configuration will break. If you want to disable the module use the NPS_ENABLED variable. for more information about the options on this variable check out the documentation page [here](https://modpagespeed.com/doc/).   
 

**NPS_RESPECTVARY** *Default:* ``off``   
In order to maximize the number of resources that PageSpeed can rewrite, by default the module does not respect ``Vary: User-Agent`` and other Vary headers on resource files, such as JavaScript and css files. By disregarding the Vary headers, PageSpeed is able to keep the size of the cache down. PageSpeed will always respect ``Vary: Accept-Encoding``, regardless of this setting. PageSpeed will also always respect Vary headers on HTML files, regardless of this setting. 
If a site has resources that legitimately vary on User-Agent, or on some other attribute, then in order to preserve that behavior, you must set ``NPS_RESPECTVARY`` on your environment variables.  

**NPS_DISABLEREWRITEONNOTRANSFORM** *Default:* ``off``   
By default, PageSpeed does not rewrite resources that have ``Cache-Control: no-transform``  set in the Response Header. This is true for all types of resources, such as JavaScript, images, CSS etc. By respecting ``Cache-Control: no-transform`` headers, PageSpeed cannot optimize resources that could otherwise be rewritten. 
To optimize resources irrespective of ``Cache-Control: no-transform`` headers, you must set ``NPS_DISABLEREWRITEONNOTRANSFORM on`` to your environment variables.  

**NPS_MODIFYCACHINGHEADERS** *Default:* ``on``  
By default, PageSpeed serves all HTML with ``Cache-Control: no-cache, max-age=0`` because the transformations made to the page may not be cacheable for extended periods of time. 
If you want to force PageSpeed to leave the original HTML caching headers you must set the ``NPS_MODIFYCACHINGHEADERS on`` to your environment variables.  

**NPS_XHEADERVALUE** *Default:* ``"Powered By jmtvms/ngx_pagespeed"``   
By default, PageSpeed adds an header, ``X-Page-Speed`` in Nginx, with the version of PageSpeed being used. The format of this header is:   
``[Major].[Minor].[Branch].[Point]-[Commit]``  
For example:   
1.9.32.3-4448  
We update these following this schedule:   
*Major Version*  
Incremented when we make very large changes.  
*Minor Version*  
Incremented for each release since the last major version  
*Branch Number*  
Incremented for every release. Always increasing.  
*Point Number*  
Incremented each time we build a new release candidate or patch release, resets on each minor release.    
*Commit Number*  
Incremented each time we accept a commit to the PSOL trunk. Always increasing.
All servers running a given release will have the same value for this header by default. If you would like to change the value reported, you can use the ``NPS_XHEADERVALUE`` environment variable to specify what to use instead.

### Exposed ports
Sinde the main idea of this contaier is to test ng_pagespeed in action it only exposes the por 80.
In the future we will make it work on https.

## How to use it

### As it is

To use the image as it is just start the container

```cmd
docker run -it -p 80:8080 jmtvms/ngx_pagespeed
```

### Set different configuration

To use this container using different configuration you can set any environment variables using the parameter ``-e "VARIABLE_NAME=value"``.

```cmd
docker run -it -p 80:8080 -e "NPS_ENABLED=off" jmtvms/ngx_pagespeed
```

This will start the container but the page speed module will be disabled.

After the container is created you can just use go to ``http://localhost:8080`` and see it working.