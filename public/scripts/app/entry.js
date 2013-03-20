
(function() {
  var app, libs;
  libs = "/scripts/libs/";
  app = '/scripts/app/';
  head.js({
    domready: libs + "ready.js"
  }, {
    raphael: libs + "raphael.js"
  }, {
    jquery: libs + "jquery.js"
  }, {
    icons: libs + 'icons.js'
  }, {
    "_": libs + 'lodash.js'
  });
  return head.ready(function() {
    var addPaper, drawIcon, getPaper, person, speed;
    addPaper = function(el) {
      var element, paper;
      paper = Raphael(el);
      element = $("svg", el);
      element.data("paper", paper);
      element.attr({
        'width': null,
        'height': null,
        'style': null
      });
      return paper;
    };
    getPaper = function(el) {
      var paper;
      return paper = $("svg", el).data('paper');
    };
    drawIcon = function(element, name, transform) {
      var bounds, icon, paper;
      paper = getPaper(element);
      if (paper == null) {
        paper = addPaper(element);
      }
      icon = paper.path(icons[name]).attr({
        fill: "#000",
        stroke: 0
      });
      bounds = icon.getBBox();
      return paper.setViewBox(bounds.x, bounds.y, bounds.width, bounds.height);
    };
    person = $("a.website");
    $('a.website').each(function(i, el) {
      return drawIcon(el, "link", "s.6,.6,0,0");
    });
    $("a.google").each(function(i, el) {
      return drawIcon(el, "gplus", "t4,4");
    });
    $("a.github").each(function(i, el) {
      return drawIcon(el, "githubalt");
    });
    $("a.facebook").each(function(i, el) {
      return drawIcon(el, "facebook", "t4,4");
    });
    speed = 100;
    $('.tabs .title .button').each(function(i, el) {
      var showClass, tabs;
      tabs = $(el).parents('.tabs');
      showClass = $(el).attr('data-shows');
      $(el).on('click', function(event) {
        var show;
        tabs.find('.active').removeClass('active');
        $(el).addClass('active');
        show = tabs.find('.content' + showClass);
        return tabs.find('.content').not(show).fadeOut(speed, function() {
          return show.fadeIn(speed);
        });
      });
      if ($(el).hasClass('active')) {
        return tabs.find('.content').not(showClass).css('display', 'none');
      }
    });
    return $('.account').on('click', function(ev) {
      var form, handler;
      form = $(">#login-form", ev.currentTarget);
      if ($(ev.target).hasClass('show-login')) {
        form.fadeToggle(speed);
        return $(document).on('click keyup', {
          form: ev.currentTarget
        }, handler = function(event) {
          if (event.type === 'keyup' && event.keyCode !== 27) {
            return;
          } else if (event.data.form === event.target || $.contains(event.data.form, event.target)) {
            return;
          }
          $(document).off('click keyup', handler);
          event.preventDefault();
          return form.fadeOut(200);
        });
      }
    });
  });
})();
