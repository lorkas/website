/*
# This script is a little silly.. it's so I can do testing by pressing ":" and typing commands.
*/

var loadKeys, logKeys;

logKeys = function(ev) {};

loadKeys = function() {
  var input, keys;
  keys = {
    ':': 58,
    ' ': 32,
    enter: 13,
    esc: 27,
    "delete": 46
  };
  input = $('<input id="#keys">');
  input.css({
    "font-size": "1.2em",
    "line-height": "1.2em",
    width: '30em',
    height: '1.2em',
    position: 'fixed',
    bottom: '.5em',
    right: '.1em',
    margin: '0',
    padding: '.1em',
    'z-index': '10000',
    opacity: ".5"
  });
  input.hide();
  $('body').append(input);
  $(document).on('keyup', function(ev) {
    logKeys(ev);
    if (ev.keyCode === keys.esc) {
      ev.preventDefault();
      return input.fadeOut(100, function() {
        return input.val('');
      });
    }
  });
  $(document).on('keypress', function(ev) {
    logKeys(ev);
    if (ev.target.tagName.toLowerCase() === "body" && ev.keyCode === keys[':']) {
      ev.preventDefault();
      return input.fadeIn(100, function() {
        return input.focus();
      });
    }
  });
  return $(input).on('keyup', function(ev) {
    var email, enter, passwd, text, _ref, _ref1, _ref2, _ref3;
    enter = ev.keyCode === keys.enter;
    text = input.val();
    if ((/^login/.exec(text) != null) && $("#login-form").css('display') === "none") {
      $(".show-login").click();
    }
    if (email = ((_ref = /^login.*-n\s*(\S*)/.exec(text)) != null ? _ref[1] : void 0) || (email = ((_ref1 = /^login.*-e\s*(\S*)/.exec(text)) != null ? _ref1[1] : void 0) || (email = (_ref2 = /^login.*-u\s*(\S*)/.exec(text)) != null ? _ref2[1] : void 0))) {
      if (email === "brent") {
        email = "brent.brimhall@gmail.com";
      }
      $('[name="login[email]"]').val(email);
    }
    if (/^login.*-p/.exec(text) != null) {
      debugger;
      $(input).css("-webkit-text-security", "disc");
      if (ev.keyCode === keys.enter) {
        $('form[name="login"]').submit();
      }
    } else {
      $(input).css("-webkit-text-security", 'initial');
    }
    if (passwd = (_ref3 = /^login.*-p\s*(\S*)/.exec(text)) != null ? _ref3[1] : void 0) {
      return $('[name="login[password]"]').val(passwd);
    }
  });
};
