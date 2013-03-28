git reset --hard # removes staged and working directory changes
git clean -f -d # remove untracked files
git pull
npm install --production
# git clean -f -x -d # CAUTION: as above but removes ignored files like config.
