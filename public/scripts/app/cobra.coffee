do ->
  libs = "/scripts/libs/"
  app = '/scripts/app/'
  head.js(
    { domready: libs+"ready.js" }
    { raphael:  libs+"raphael.js" }
    { jquery:   libs+"jquery.js" }
    { icons:    libs+'icons.js'}
    { "_":      libs+'lodash.js' }
    { keys:     app+'vimkeys.js' }
  )


  head.ready ->
    $('.card .description').on 'mouseover', -> false

