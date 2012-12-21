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
    console.log 'up', ev.keyCode
    if ev.keyCode is keys.delete
      debugger
    if ev.keyCode is keys.esc
      ev.preventDefault()
      input.fadeOut 100, -> input.val ''

  $(document).on 'keypress', (ev) ->
    console.log 'press', ev.keyCode

    if ev.keyCode is keys[':']
      ev.preventDefault()
      input.fadeIn 100, ->
        input.focus()
        
  $(input).on 'keyup', (ev) ->
    if input.val() is 'login'
      $(".show-login").click()


