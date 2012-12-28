_ = require 'lodash'
User = require(process.cwd()+"/server/user")

members = require "#{process.cwd()}/server/members"

account = require('./account')

module.exports = (app) ->
  app.get '*', account.useUser

  app.get '/d', (req, res, next) -> debugger

  require('./account') app
  # require('./openid') app

  app.get '/',              (req, res) -> res.render 'index',         title: 'About LOrkAS'
  app.get '/roadmap',       (req, res) -> res.render 'roadmap',       title: 'roadmap'
  app.get '/people',        (req, res) -> res.render 'people',        short: 'People of LOrkAS', title: 'The People of LOrkAS', people: members
  app.get '/performances',  (req, res) -> res.render 'performances',  title: 'Performances'
  app.get '/repertoire',    (req, res) -> res.render 'repertoire',    short: 'Repertoire', title: 'Our Repertoire'
  app.get '/contact',       (req, res) -> res.render 'contact',       title: 'Contact Us'

  app.get '*', (req, res) ->
    res.status 404
    if req.accepts 'html' then res.render '404', { url: req.url, title: "404 Not Found" }
    else if req.accepts 'json' then res.send { error: 'Not found' }
    else res.type('txt').send 'Not found'
