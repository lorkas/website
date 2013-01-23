###
# User account actions
###
_ = require 'lodash'
User = require "#{process.cwd()}/server/user"

account =
  # Inject user to the locals var so you can use it in templates and stuff.
  useUser: (req, res, next) ->
    res.locals.user = req.user
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
      res.render '', title: 'Create new account'

# So you can require this file and have account related routed middleware.
module.exports = _.extend setRoutes, account
