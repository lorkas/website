everyauth = require 'everyauth'
mongoose = require 'mongoose'
Schema = mongoose.Schema

User = require(process.cwd()+"/server/user")
config = require(process.cwd() + '/config').oauth


everyauth.everymodule.configure
  findUserById: (email, callback) ->
    User.find 'email', email, callback
  logoutPath: '/logout'
  logoutRedirectPath: '/'
  handleLogout: (req, res) ->
    req.logout()
    req.session.destroy (err) ->
      if err?
        res.send "Error logging out, please try again: #{err}"
      else
        res.redirect 'back'


everyauth.facebook.configure
  appId: config.facebook.appId
  appSecret: config.facebook.appSecret
  handleAuthCallbackError: (req, res) ->
    console.error "Callback error", req, res
    # If a user denies your app, Google will redirect the user to /auth/google/callback?error=access_denied
    # This configurable route handler defines how you want to respond to that.  If you do not configure
    # this, everyauth renders a default fallback view notifying the user that their authentication failed and why.
  findOrCreateUser: (session, accessToken, accessTokenExtra, user) ->
    debugger
    promise = @Promise()
    return User.findOne({ 'oauth.facebook.id': user.id }).exec (err, user) ->
      if user?
        promise.fulfill if err? then [err] else user
      else
        if session.user?
          (session.user.auth = {}).facebook = user
          session.user.save()
        else
          console.log "New acct."
  redirectPath: '/'
  scope: 'email'
  entryPath: '/auth/facebook'
  callbackPath: '/auth/facebook/callback'


everyauth.google.configure
  appId: config.google.appId
  appSecret: config.google.appSecret
  scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile' # What you want access to
  handleAuthCallbackError: (req, res) ->
    console.error "Callback error", req, res
  findOrCreateUser: (session, accessToken, accessTokenExtra, user) ->
    promise = @Promise()
    return User.findOne({ 'oauth.google.id': user.id }).exec (err, user) ->
      if user?
        promise.fulfill if err? then [err] else user
      else
        console.log "New acct."

  redirectPath: '/'
  entryPath: '/auth/google'
  callbackPath: '/auth/google/callback'

everyauth.github.configure
  appId: config.github.appId
  appSecret: config.github.appSecret
  scope: 'user, gist' # What you want access to
  handleAuthCallbackError: (req, res) ->
    console.error "Callback error", req, res
  findOrCreateUser: (session, accessToken, accessTokenExtra, user) ->
    promise = @Promise()
    return User.findOne({ 'oauth.github.id': user.id }).exec (err, user) ->
      if user?
        promise.fulfill if err? then [err] else user
      else
        console.log "New acct."


  redirectPath: '/'
  entryPath: '/auth/github'
  callbackPath: '/auth/github/callback'



module.exports = everyauth
