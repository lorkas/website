var loadKeys;

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
    console.log('up', ev.keyCode);
    if (ev.keyCode === keys["delete"]) {
      debugger;
    }
    if (ev.keyCode === keys.esc) {
      ev.preventDefault();
      return input.fadeOut(100, function() {
        return input.val('');
      });
    }
  });
  $(document).on('keypress', function(ev) {
    console.log('press', ev.keyCode);
    if (ev.keyCode === keys[':']) {
      ev.preventDefault();
      return input.fadeIn(100, function() {
        return input.focus();
      });
    }
  });
  return $(input).on('keyup', function(ev) {
    if (input.val() === 'login') {
      return $(".show-login").click();
    }
  });
};
