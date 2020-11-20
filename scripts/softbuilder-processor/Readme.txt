=============
FS STRUCUTRE 
=============

/opt/softbuilder-processor
drwxr-xr-x 4 root root   4096 Nov  7  2019 ..
drwxr-xr-x 2 root root   4096 Nov 20 09:56 bin/softbuilder-processor.py
drwxr-xr-x 3 root root  12288 Nov 20 09:48 errors/
drwxr-xr-x 2 root root   4096 Mar 10  2020 etc/config.cfg
drwxr-xr-x 2 root root   4096 Nov 20 09:12 incoming
drwxr-xr-x 2 root root   4096 Nov 18 11:31 log
drwxr-xr-x 2 root root 196608 Nov 19 15:15 processados
drwxr-xr-x 2 root root   4096 Feb  5  2020 tmp
drwxr-xr-x 2 root root   4096 Nov 20 11:05 decoder_issues


====
CRON
====
*/5 * * * * /opt/softbuilder-processor/bin/softbuilder-processor.py -c /opt/softbuilder-processor/etc/config.cfg
