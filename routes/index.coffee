_ = require 'underscore'
User = require(process.cwd()+"/server/user")

members = require "#{process.cwd()}/server/members"

module.exports = (app) ->

  app.get '*', (req, res, next) ->
    if not req.session.user? and req.session.auth?.loggedIn
      auth = req.session.auth
      _.find ['google', 'facebook', 'github'], (name) ->
        return false unless auth[name]
        a = {}
        a['ouath.'+auth[name]+'.id'] = auth[name].id
        if a?
          User.findOne(a).exec (err, user) ->
            req.session.user = user
            req.session.save()
            res.locals.user = user
            next()
          return true
        else
          next()
          return true
    else
      user = req.session.user
      res.locals.user = user
      next()

  app.get '/d', (req, res, next) -> debugger
  require('./account') app
  # require('./openid') app
  
  app.get '/',              (req, res) -> res.render 'index',         title: 'About LOrkAS'
  app.get '/roadmap',       (req, res) -> res.render 'roadmap',       title: 'roadmap'
  app.get '/people',        (req, res) -> res.render 'people',        short: 'People of LOrkAS', title: 'The People of LOrkAS', people: members
  app.get '/performances',  (req, res) -> res.render 'performances',  title: 'Performances'
  app.get '/repertoire',    (req, res) -> res.render 'repertoire',    short: 'Repertoire', title: 'Our Repertoire'
  app.get '/contact',       (req, res) -> res.render 'contact',       title: 'Contact Us'
  app.get '/myacct',
    (req, res,next) ->
      if not res.locals.user?
        res.redirect '/'
      else
        next()
  ,
    (req, res) -> res.render 'account', title: 'Account for ' + res.locals.user.name || res.locals.user.email

  app.get '*', (req, res) ->
    res.status 404

    if req.accepts 'html'
      res.render '404', { url: req.url, title: "404 Not Found" }
    else if req.accepts 'json'
      res.send { error: 'Not found' }
    else
      res.type('txt').send 'Not found'
