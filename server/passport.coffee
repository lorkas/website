###
# Login Strategy:
# Has the account been linked? I.e. is there an account with the oauth ID?
# If not, oh well!
#
# Is the user logged in? # in the passport oauth lookup ##DONE
#   y: Link their accounts? # ask @ express account page
#     y: add to their account
#     n:
#   n: Create a new account? # ask @ express account page - failure redirect
#     Register strategy:
#     Get the account
#     Is there already a user with the same email address?
#       y: Do they want to create a new account, or use the old one?
#         If they want a new one, flag the account.
#       n: Create a new account
###

async = require 'async'
_ = require 'lodash'
mongoose = require 'mongoose'
Schema = mongoose.Schema

User = require(process.cwd()+"/server/user")
config = require(process.cwd() + '/config').oauth
url = "http://localhost:3100"

passport = require 'passport'

###
#  Set up overall strategies
###

# Serialize and deserialize a user based on their user id
passport.serializeUser (user, next) -> next null, user.id
passport.deserializeUser (id, next) -> User.findById id, next

# This is the callback to validate oauth logins
validateUser = (req, accessToken, refreshToken, profile, next) ->
  User.findOne { oauth: { $elemMatch: { id: profile.id }}}, (err, foundUser) ->
    loggedIn = req.user
    # continue if there's an error
    return next err if err?
    # If the foundUser isn't logged in and the oauth acct is associated with someone, log it in.
    if not loggedIn and foundUser
      req.login foundUser, next
    # If the foundUser is logged in and the oauth acct isn't already associated with someone, add the account.
    else if loggedIn and not foundUser
      res.redirect "/account/oauth-associate"
      # loggedIn.oauth.push profile
      # loggedIn.save next
    # If the foundUser is not logged in and the oauth account is not associated with someone, register it
    else if not loggedIn and not foundUser
      res.redirect "/account/register"
      throw "NIY - make a page redirect to do this!!!".red
    # If the foundUser is logged in and the oauth acct IS already associated with an account
    else if loggedIn and foundUser
      # If it's the same one, just ignore it
      if loggedIn.id is foundUser.id
        console.log "ignoring, they're the same foundUser."
        next()
      # If it's a different one, be like wtf you need to disassociate your other account before adding to this
      else
        console.log err = "This should not happen >> handle it!!"
        next err

# Settings that apply to all logins
globalConfig =
  passReqToCallback: true

LocalStrategy = require('passport-local').Strategy
passport.use new LocalStrategy _.extend(_.clone(globalConfig),
    usernameField: 'login[email]'
    passwordField: 'login[password]'
  ), (req, email, password, next) ->
    User.findOne { email: email }, (err, user) ->
      return next err if err
      if not user
        next null, false, { message: 'Incorrect username.' }
      else
        user.comparePassword password, (err, isMatch)->
          if not isMatch
            return next null, false, { message: 'Incorrect password.' }
          else
            return next null, user


GoogleStrategy = require('passport-google-oauth').OAuth2Strategy
passport.use new GoogleStrategy _.extend(_.clone(config.google), globalConfig,
  callbackURL: url+'/auth/google/callback'
), validateUser
      
FacebookStrategy = require('passport-facebook').Strategy
passport.use new FacebookStrategy _.extend(_.clone(config.facebook), globalConfig,
  callbackURL: url+"/auth/facebook/callback"
), validateUser

GithubStrategy = require('passport-github').Strategy
passport.use new GithubStrategy _.extend(_.clone(config.github), globalConfig,
  callbackURL: url+"/auth/github/callback"
), validateUser

###
#  Set up paths
###

module.exports = (app) ->
  # for everything
  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect '/'

  app.post '/auth/login', (req, res, next) ->
    passport.authenticate( 'local', (err, user, info) ->
      if err or not user
        res.locals.message = "Login failed."
        res.redirect '/'
      else
        req.login user, (err) ->
          if err
            next err
          else
            res.redirect '/'
    ) req, res, next
        

  
  # for google
  gapiURL = 'https://www.googleapis.com/auth/'
  app.get '/auth/google', passport.authenticate('google', scope: [gapiURL+'userinfo.profile', gapiURL+'userinfo.email'])
  app.get '/auth/google/callback', passport.authenticate 'google', { successRedirect: '/', failureRedirect: '/' }

  # for facebook
  app.get '/auth/facebook', passport.authenticate 'facebook', scope: ['read_stream', 'publish_actions'] # callbackURL: url+'/auth/facebook/callback'
  app.get '/auth/facebook/callback', passport.authenticate 'facebook', { successRedirect: '/', failureRedirect: '/' }

  # for github
  app.get '/auth/github', passport.authenticate 'github'
  app.get '/auth/github/callback', passport.authenticate('github', { failureRedirect: '/' }), (req, res) -> res.redirect '/'
