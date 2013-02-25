#!/bin/bash

# Good bash reference:
# http://www.ibm.com/developerworks/linux/library/l-bash/index.html
# http://www.ibm.com/developerworks/linux/library/l-bash2/index.html
# http://www.ibm.com/developerworks/linux/library/l-bash3/index.html

# Parse the arguments

if [ "$1" = "--update" ]; then
  echo "Updating"
  git reset --hard # removes staged and working directory changes
  git clean -f -d # remove untracked files
  git pull
  npm install
  # git clean -f -x -d # CAUTION: as above but removes ignored files like config.
  exit
fi


for arg in $@; do
  case "$arg" in
    -d)
      echo "debugging"
      DEBUG_MODE=true
      ;;
    --server)
      ENV=prod
      ;;
  esac
done

if [ $ENV == "dev" ]; then
  if [ -n "$DEBUG_MODE" ]; then
    DEBUG_MODE="--debug"
    NODEJS_ARG=true
  fi

  if [ -n "$NODEJS_ARG" ]; then
    NODEJS_ARG="--nodejs"
  fi

  # I can't get redux to use the debugger, so we use redux
  # if we don't need the debugger, regular otherwise.
  if [ -n "$NODEJS_ARG" ]; then
    echo "Using coffeescript"
    coffee ${NODEJS_ARG} ${DEBUG_MODE} app.coffee
  else
    echo "Using coffeescript redux"
    ./node_modules/coffee-script-redux/bin/coffee --require source-map-support app.coffee
  fi
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
