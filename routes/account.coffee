###
# User account actions
###
_ = require 'underscore'
User = require "#{process.cwd()}/server/user"

module.exports = (app) ->
  app.post '/auth/login', (req, res, next) ->
    login = req.body?.login
    return unless login?

    User.getAuthenticated login.email, login.password, (err, user, reason) ->
      throw err if err
      if user?
        req.login user, -> res.redirect 'back'
      else
        reasons = User.failedLogin
        switch reason
          when reasons.NOT_FOUND, reasons.PASSWORD_INCORRECT
            # note: these cases are usually treated the same - don't tell the user *why* the login failed, only that it did
            console.log reason
          when reasons.MAX_ATTEMPTS
            # send email or otherwise notify user that account is temporarily locked
            console.log reason
        res.redirect 'back'

  app.get '/auth/register', (req, res) -> res.redirect '/'
  app.post '/auth/register', (req, res, next) ->
    register = req.body?.register
    return unless register?

    User.findOne { email: register.email }, (err, oldUser) ->
      if oldUser?
        return res.send 304, "User already created"
      else
        u = {}
        u.email =     if register.email?     then register.email
        u.password =  if register.password?  then register.password
        u.name =      if register.name?      then register.name
        u.position =  if register.position?  then  _.filter register.position, ((el) -> return el if el.length > 0 )
        u.bio =       if register.bio?       then register.bio
        user = new User u
        console.log u, user
        user.save (err, user) ->
          return res.send "Error saving new user" if err
          # req.session.user = user
          res.redirect '/myacct'

