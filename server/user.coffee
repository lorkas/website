# Using this auth method:
# http://devsmash.com/blog/implementing-max-login-attempts-with-mongoose

###
# TODO: Switch to mongoskin for db access, use bilby for controller object.
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
bcrypt = require('bcrypt')
SALT_WORK_FACTOR = 10
MAX_LOGIN_ATTEMPTS = 5
LOCK_TIME = 60 * 1000

UserSchema = new mongoose.Schema
  email: { type: String, index: { unique: true } }
  password: { type: String }
  loginAttempts: { type: Number, required: true, default: 0 }
  lockUntil: { type: Number }

  name: String
  bio: String
  position: [String]

  oauth: []

UserSchema.virtual('isLocked').get ->
    # check for a future lockUntil timestamp
    return !!(this.lockUntil && this.lockUntil > Date.now())

UserSchema.pre 'save', (next) ->
    user = this

    # only hash the password if it has been modified (or is new)
    return next() if !user.isModified('password')

    # generate a salt
    bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
      return next err if err

      # hash the password using our new salt
      bcrypt.hash user.password, salt, (err, hash) ->
        return next err if err

        # set the hashed password back on our user document
        user.password = hash
        next()

UserSchema.methods.comparePassword = (candidatePassword, cb) ->
  bcrypt.compare candidatePassword, this.password, (err, isMatch) ->
    return cb err if err
    cb null, isMatch

UserSchema.methods.incLoginAttempts = (cb) ->
  # if we have a previous lock that has expired, restart at 1
  if this.lockUntil && this.lockUntil < Date.now()
    return this.update {
      $set: { loginAttempts: 1 }
      $unset: { lockUntil: 1 }
    }, cb
  # otherwise we're incrementing
  updates = $inc: { loginAttempts: 1 }
  # lock the account if we've reached max attempts and it's not locked already
  if this.loginAttempts + 1 >= MAX_LOGIN_ATTEMPTS && !this.isLocked
      updates.$set = lockUntil: Date.now() + LOCK_TIME
  return this.update updates, cb

reasons = UserSchema.statics.failedLogin =
  NOT_FOUND: "not found"
  PASSWORD_INCORRECT: "password incorrect"
  MAX_ATTEMPTS: 'max attempts reached'

UserSchema.statics.getAuthenticated = (username, password, cb) ->
  this.findOne { email: username }, (err, user) ->
    return cb err if err

    # make sure the user exists
    return cb null, null, reasons.NOT_FOUND if not user

    # check if the account is currently locked
    if user.isLocked
      # just increment login attempts if account is already locked
      return user.incLoginAttempts (err) ->
        return cb err if err?
        return cb null, null, reasons.MAX_ATTEMPTS

    # test for a matching password
    user.comparePassword password, (err, isMatch) ->
      return cb err if err?

      # check if the password was a match
      if isMatch
        # if there's no lock or failed attempts, just return the user
        return cb null, user unless user.loginAttempts or user.lockUntil
        # reset attempts and lock info
        updates =
          $set: { loginAttempts: 0 }
          $unset: { lockUntil: 1 }
        return user.update updates, (err) ->
          return cb err if err
          return cb null, user

      # password is incorrect, so increment login attempts before responding
      user.incLoginAttempts (err) ->
        return cb err if err
        return cb null, null, reasons.PASSWORD_INCORRECT

module.exports = mongoose.model('User', UserSchema)
