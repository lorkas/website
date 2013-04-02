#!/bin/bash

# Good bash reference:
# http://www.ibm.com/developerworks/linux/library/l-bash/index.html
# http://www.ibm.com/developerworks/linux/library/l-bash2/index.html
# http://www.ibm.com/developerworks/linux/library/l-bash3/index.html

LOGPATH=$PWD
forever start -a -l $LOGPATH/logs/log.log -o $LOGPATH/logs/error.log -e $LOGPATH/logs/error.log  -c coffee app.coffee
# nohup forever -m 30 -l logs/log.log -o logs/error.log -e logs/error.log  -c coffee app.coffee &> logs/nohup.log & 

