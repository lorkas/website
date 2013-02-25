account = require('./account')
members = require "#{process.cwd()}/server/members"
User = require(process.cwd()+"/server/user")

module.exports = (app) ->
  app.get '*', account.useUser

  # app.get '/d', (req, res, next) -> debugger

  app.get '/', (req, res) ->
    res.render 'index', title: 'About LOrkAS'
  app.get '/cobra', (req, res) ->
    res.render 'cobra', entry: '/scripts/app/cobra', title: 'cobra'
  app.get '/roadmap', (req, res) ->
    res.render 'roadmap', title: 'roadmap'
  app.get '/people', (req, res) ->
    res.render 'people', short: 'People of LOrkAS', title: 'The People of LOrkAS', people: members
  app.get '/media', (req, res) ->
    res.render 'media', title: 'Media'
  app.get '/performances', (req, res) ->
    res.render 'performances', title: 'Performances'
  app.get '/repertoire', (req, res) ->
    res.render 'repertoire', short: 'Repertoire', title: 'Our Repertoire'
  app.get '/press', (req, res) ->
    res.render 'press', title: 'Press'
  app.get '/contact', (req, res) ->
    res.render 'contact', title: 'Contact Us'

  app.get '/members-only', account.requireUser, (req, res) ->
    res.render 'members-only', title: 'Because You Are Special'

  require('./account') app

  app.get '*', (req, res) ->
    res.status 404
    if req.accepts 'html' then res.render '404', { url: req.url, title: "404 Not Found" }
    else if req.accepts 'json' then res.send { error: 'Not found' }
    else res.type('txt').send 'Not found'
