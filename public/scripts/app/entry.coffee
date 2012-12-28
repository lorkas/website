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
    addPaper = (el) ->
      paper = Raphael el
      element = $("svg", el)
      element.data "paper", paper
      element.attr 'width': null, 'height': null, 'style': null
      return paper
    getPaper = (el) ->
      paper = $("svg", el).data 'paper'
    drawIcon = (element, name, transform) ->
      paper = getPaper element
      paper = addPaper element unless paper?

      icon = paper.path(icons[name]).attr({fill: "#000", stroke: 0})
      bounds = icon.getBBox()

      paper.setViewBox bounds.x, bounds.y, bounds.width, bounds.height

    person = $ "a.website"
    $('a.website').each (i, el) -> drawIcon el, "link", "s.6,.6,0,0"
    $("a.google").each (i, el) -> drawIcon el, "gplus", "t4,4"
    $("a.github").each (i, el) -> drawIcon el, "githubalt"
    $("a.facebook").each (i, el) -> drawIcon el, "facebook", "t4,4"

    # Switch between login and register tabs
    speed = 100
    $('.tabs .title .button').each (i, el) ->
      tabs = $(el).parents('.tabs')
      showClass = $(el).attr('data-shows')
      $(el).on 'click', (event) ->
        # Make the current tab .active
        tabs.find('.active').removeClass 'active'
        $(el).addClass 'active'
      
        # Hide everything but the current tab content area
        show = tabs.find('.content'+showClass)
        tabs.find('.content').not(show).fadeOut speed, ->
          show.fadeIn speed

      if $(el).hasClass 'active'
        tabs.find('.content').not(showClass).css('display', 'none')


    # Show/hide login form in header
    $('.account').on 'click', (ev) ->
      form = $ ">#login-form", ev.currentTarget
      if $(ev.target).hasClass 'show-login'
        form.fadeToggle speed
        $(document).on 'click keyup', { form: ev.currentTarget }, handler = (event) ->
          if event.type is 'keyup' and event.keyCode isnt 27
            return
          else if event.data.form is event.target or $.contains event.data.form, event.target
            return
          $(document).off 'click keyup', handler
          event.preventDefault()
          form.fadeOut 200

    loadKeys()

