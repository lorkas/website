###
# This script is a little silly.. it's so I can do testing by pressing ":" and typing commands.
###

logKeys = (ev) -> # console.log ev.keyCode

# # this doesn't work yet...
# command = /^(\S{0,})[$\s]/ # get the command, e.g. "grep -R" would return "grep"
# argumentWord = /(--\w+)\s*(\S+)\s*/g
# argumentLetter = /(-\w)\s*(\S+)\s*/g
# argName = /^-{1,2}(\w)/ # returns "asdf" for "--asdf" or "d" for "-d"
# window.parseArgs = (string) ->
#   cmd = command.exec(string)?[1]
#   args = argument.exec(string)
#   debugger
#   args = args.slice 1, args.length
#   argObj = {}
#   for test in [argumentWord, argmentLetter]
#   while args.length > 0
#     continue unless (arg = args.shift())?
#     if (name = test.exec(arg)?[1])
#       argObj[name] = args.shift()
#   debugger
# parseArgs "asdf -a qqwer --bigger argument"

loadKeys = ->
  keys =
    ':': 58
    ' ': 32
    enter: 13
    esc: 27
    delete: 46

  input = $ '<input id="#keys">'
  input.css
    "font-size": "1.2em"
    "line-height": "1.2em"
    width: '30em'
    height: '1.2em'
    position: 'fixed'
    bottom: '.5em'
    right: '.1em'
    margin: '0'
    padding: '.1em'
    'z-index': '10000'
    opacity: ".5"
  input.hide()
  $('body').append input

  $(document).on 'keyup', (ev) ->
    logKeys ev
    if ev.keyCode is keys.esc
      ev.preventDefault()
      input.fadeOut 100, -> input.val ''

  $(document).on 'keypress', (ev) ->
    logKeys ev
    if ev.target.tagName.toLowerCase() is "body" and ev.keyCode is keys[':']
      ev.preventDefault()
      input.fadeIn 100, ->
        input.focus()
        
  $(input).on 'keyup', (ev) ->
    enter = ev.keyCode is keys.enter
    text = input.val()
    # login stuff -------------------------------------------------------
    # show login form
    if /^login/.exec(text)? and $("#login-form").css('display') is "none"
      $(".show-login").click()
    # get login name
    if email = /^login.*-n\s*(\S*)/.exec(text)?[1] or
    email = /^login.*-e\s*(\S*)/.exec(text)?[1] or 
    email = /^login.*-u\s*(\S*)/.exec(text)?[1]
      if email is "brent" then email = "brent.brimhall@gmail.com"
      $('[name="login[email]"]').val email
    if /^login.*-p/.exec(text)?
      debugger
      $(input).css("-webkit-text-security","disc")
      if ev.keyCode is keys.enter then $('form[name="login"]').submit()
    else
      $(input).css("-webkit-text-security",'initial')
    if passwd = /^login.*-p\s*(\S*)/.exec(text)?[1]
      $('[name="login[password]"]').val passwd


