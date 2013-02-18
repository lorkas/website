logKeys = (ev) -> # console.log ev.keyCode

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
    if ev.keyCode is keys.delete
      debugger
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
    email = /^login.*-e\s*(\S*)/.exec(text)?[1]
      if email is "brent" then email = "brent.brimhall@gmail.com"
      $('[name="login[email]"]').val email
    if passwd = /^login.*-p\s*(\S*)/.exec(text)?[1]
      $(input).css("-webkit-text-security","disc")
      $('[name="login[password]"]').val passwd
      if ev.keyCode is keys.enter then $('form[name="login"]').submit()
    else
      $(input).css("-webkit-text-security",'initial')




