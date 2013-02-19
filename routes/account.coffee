###
# User account actions
###
lodash = require 'lodash'
User = require "#{process.cwd()}/server/user"

account =
  # Inject user to the locals var so you can use it in templates and stuff.
  useUser: (req, res, next) ->
    res.locals.user = req.user
    res.locals.loggedIn = req.user? # since this line is awkward in jade
    next null

  # Reroute home if you're not logged in.
  requireUser: (req, res, next) ->
    if not req.user
      res.redirect '/'
    else
      next null

setRoutes = (app) ->
  if app
    app.get '/account', account.requireUser, (req, res) ->
      res.render 'account', title: 'Account for ' + req.user.name || req.user.email
    app.get '/account/oauth-associate', account.requireUser, (req, res) ->
      res.render 'associate_account', title: 'Link accounts'
    app.get '/account/register', (req, res) ->
      res.render 'register', title: 'Create new account', newUser: req.session.newUser
    app.post '/account/register', (req, res, etc...) ->
      data = req.body.account
      newUser = new User()
      newUser.email= data.email if data.email?
      newUser.name= data.name if data.name?
      newUser.password= data.password if data.password?
      newUser.bio= data.bio if data.bio?
      if req.session?.newUser?
        newUser.oauth.push req.session.newUser
      newUser.save (err, user) ->
        if err?
          res.locals.message = "Error " + err
          console.log "Error\n".red, ":".blue
          console.dir err
          console.log "/error\n".red
        else
          req.login user, {}, (args...) ->
            debugger
            res.redirect '/account'

# So you can require this file and have account related routed middleware.
module.exports = lodash.extend setRoutes, account
