#!./node_modules/.bin/coffee

pkg = 
  name: "LOrkAS_website"
  version: "0.0.1"
  private: true
  notes: """
    Please make changes to package.coffee instead of package.json.
    Running npm install will run the coffee file first, which overwrites the json file.
    This is useful becasue you can add comments to coffee files, but not json files.
  """
  dependencies:
    "express": "3.4.x"
    ###
    # Express is the framework for the whole site - the most popular one for node.js
    # Good api documentation: http://expressjs.com/
    # Express uses connect middleware - all the app.use stuff is middleware.
    # Connect docs are at: www.senchalabs.org/connect/
    ###
    
    # Coffeescript is "uncomplicated javascript". It's a language that compiles into javascript,
    # and is soo much easier to read and write. Great docs, and the "Try Coffeescript" thing on their website
    # is VERY useful. http://coffeescript.org
    "coffee-script": "1.6.x"

    # Jade is a language that compiles to HTML.
    # Their github page has all the docs: https://github.com/visionmedia/jade - their actual website sucks.

    "jade": "*"
    # Styles compiles to CSS. It is much cleaner, and takes care of a lot of the annoying details for you.
    # http://learnboost.github.com/stylus/
    "stylus": "x"
    # Nib is an extension for stylus that includes some nice tools.
    "nib": "x"

    # Async is a lib for asynchronous flow control.
    # https://github.com/caolan/async
    "async": "x"
    # lets you log things to the console in full color.
    "colors": "x"
    # It automatically compiles coffeescript before sending it to the client. It makes coffee nicer and easier.
    "connect-coffee-script": "x"
    "markdown-js": "x"
    # lodash is functional programming for javascript. Like underscore but better. http://lodash.com/docs
    "lodash": "x"
  devDependencies:
    # Passport is what lets us use google, facebook, etc for logins.
    "passport": "x"
    # the passport-* packages are adapters for different oauth providers. passport-local is for local logins instead of oauth logins.
    "passport-local": "x"
    "passport-facebook": "x"
    "passport-google-oauth": "x"
    "passport-github": "x"

    # bcrypt is for password hashing, so we don't store people's passwords in our database.
    "bcrypt": "x"
    # connect-mongo lets us use mongodb for web sessions.
    "connect-mongo": "x"
    # mongoskin is a wrapper for the mongodb driver.
    "mongoose": "x"
    "mongoskin": "x"
  scripts:
    start: "coffee app.coffee"
    preinstall: "coffee package.coffee"
  volo: # Volo is a package manager for client side libraries.
    "baseDir": "public/scripts/libs"
    "dependencies":
      "domready": "github:ded/domready/master"
      "bean": "github:fat/bean/v1.0.2"
      "bonzo": "github:ded/bonzo/v1.0.0"
      "upload": "github:amccollum/upload/master"
      "traversty": "github:rvagg/traversty/master"
      "Radio": "github:uxder/Radio/v0.2.0"
      "moment": "github:timrwood/moment/1.7.2"
      "eventify": "github:bermi/eventify/master"
      "drag": "github:logicalparadox/drag.js/0.0.4"
      "FitText": "github:davatron5000/FitText.js/master"
      "Lettering": "github:davatron5000/Lettering.js/v0.6.1"
      "require": "github:jrburke/requirejs/2.1.2"
      "raphael": "github:metacommunications/raphael/v2.1.0"
      "lodash": "github:bestiejs/lodash/v0.10.0"

try colors = require 'colors'
log =
  if colors? then (text, color) -> console.log colors[color](text)
  else (text) -> console.log text

# Parse and write the file with a 2 space indent
json_pkg = JSON.stringify pkg, undefined, 2
require('fs').writeFileSync "package.json", json_pkg
log json_pkg, 'grey'
log "Written\n\n", 'green'


