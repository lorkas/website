#!/bin/bash

# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_02.html

# Ya, still working on this...

export ENV=dev
if [ $ENV == "dev" ]; then
  coffee app.coffee
else
  forever -m 30 -l logs/log.log -o logs/error.log -e logs/error.log  -c coffee app.coffee & 
fi

# SERVER="$s"
# echo "$SERVER"

# export ENV=prod
# if [ ENV == "prod" ]; then
#   export EXPRESS_PORT=3100
#   echo "prod"
# else
#   export EXPRESS_PORT=3100
#   echo "dev"
# fi

# coffee app.coffee
