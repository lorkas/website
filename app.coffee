# use machina - https://github.com/ifandelse/machina.js - for client routing?

coffeescript = require 'connect-coffee-script'
config = require process.cwd()+'/config'
require 'colors'
express = require 'express'
http = require 'http'
mongoose = require 'mongoose'
nib = require 'nib'
passport = require 'passport'
path = require 'path'
routes = require './routes'
stylus = require 'stylus'

app = express()
MongoStore = require('connect-mongo') express

db = mongoose.connect 'local.host', 'lorkas'
# db.on 'error', console.error.bind console, 'connection error:'
# db.once 'open', (args...) ->
#   console.log 'db open', args...

# Set up the app
app.configure ->
  app.set 'port', config.port
  app.use express.favicon()
  app.use express.logger('dev')
  # app.use express.logger ':method :url - :referrer, :req[content-type] -> :res[content-type]'
  app.use coffeescript src: process.cwd()+"/public", bare: true

  app.use stylus.middleware src: process.cwd()+"/public", compile: (str, path) ->
      stylus( str).set( 'force', true).set( 'filename', path
      ).set( 'compress', false
      ).use( nib()).import( 'nib' )

  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser 'make this a random thing!'
  app.use express.session
    secret: 'AP$&U7DMK_Qj7gx!FPPX4KKCQB&dCDnLGM(qZ(wAQQvEe45L'
    store: new MongoStore
      mongoose_connection: db.connections[0]
  app.use express.static path.join __dirname, 'public'
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use passport.initialize()
  app.use passport.session()
  app.use app.router

app.locals
  inspect: require('util').inspect
  util: require 'util'

require('./server/passport') app, passport

# This is only used while developing
app.configure 'development', -> app.use express.errorHandler()

# Set up the routes - see routes/index.coffee
routes app

# And initialize the server.
http.createServer(app).listen app.get('port'), ->
  console.log "Lorkas' Express server listening on port #{app.get 'port'}"

