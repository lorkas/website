#!/bin/bash

# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_02.html

# Ya, still working on this...

# export ENV=dev
if [ $ENV == "dev" ]; then
  ./node_modules/coffee-script-redux/bin/coffee app.coffee
else
  # Just using tmux for now.. bad me.
  forever -m 30 -l logs/log.log -o logs/error.log -e logs/error.log  -c coffee app.coffee
  # nohup forever -m 30 -l logs/log.log -o logs/error.log -e logs/error.log  -c coffee app.coffee &> logs/nohup.log & 
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
