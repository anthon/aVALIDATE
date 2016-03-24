// Generated by CoffeeScript 1.10.0
(function() {
  (function($, window, undefined_) {
    return $.fn.validate = function(options) {
      var $form, $styles, checkInput, checkValidation, defaults, email_pattern, required_length, runReg, settings;
      $styles = $('<style id="aVALIDATE_styles"> [required] { position: relative; } [required]:after { content: " \\002a"; color: #F00; } .aVALIDATE_passed:after { color: #0F0; } </style>');
      defaults = {
        requiredSelector: '.required,[required="required"]',
        emailName: 'email'
      };
      settings = $.extend({}, defaults, options);
      email_pattern = /^.+@.+[.].{2,}$/i;
      required_length = 0;
      $form = null;
      checkInput = function($form, $required) {
        var $field;
        $field = $required.is('input,textarea') ? $required : $required.find('input,textarea');
        return $field.on('keyup change input propertychange', function(e) {
          var accept, extension, file, files, i, len, max_size, passed;
          if (e.keyCode === 13) {
            e.preventDefault();
          }
          switch ($field.attr('type')) {
            case 'file':
              passed = false;
              files = $field[0].files;
              accept = $field.attr('accept');
              max_size = $field.data('max-size') * 1024 * 1024;
              for (i = 0, len = files.length; i < len; i++) {
                file = files[i];
                console.log(file);
                if (accept) {
                  if (accept.indexOf('/')) {
                    if (accept === file.type) {
                      passed = true;
                    }
                  } else {
                    extension = '.' + file.name.split('.').pop();
                    if (accept.indexOf(extension)) {
                      passed = true;
                    }
                  }
                }
                if (max_size) {
                  passed = false;
                  if (parseInt(max_size) > file.size) {
                    passed = true;
                  }
                }
              }
              if (passed) {
                $required.addClass('aVALIDATE_passed');
              }
              break;
            default:
              if ($field.val().length >= 2) {
                $required.addClass('aVALIDATE_passed');
                if ($field.is('[name=' + settings.emailName + ']') && !runReg($field.val())) {
                  $required.removeClass('aVALIDATE_passed');
                }
              } else {
                $required.removeClass('aVALIDATE_passed');
              }
          }
          return checkValidation();
        });
      };
      runReg = function(string) {
        return email_pattern.test(string);
      };
      checkValidation = function() {
        var $submit;
        $submit = $form.find(":submit");
        if (required_length === $form.find(".aVALIDATE_passed").length) {
          return $submit.removeAttr('disabled').css({
            opacity: 1
          });
        } else {
          return $submit.attr('disabled', 'disabled').css({
            opacity: .24
          });
        }
      };
      return this.each(function() {
        if ($('style#aVALIDATE_styles').length === 0) {
          $('head').append($styles);
        }
        $form = $(this);
        required_length = $form.find(settings.requiredSelector).length;
        checkValidation();
        return $form.find(settings.requiredSelector).each(function() {
          var $this;
          $this = $(this);
          return checkInput($form, $this);
        });
      });
    };
  })(jQuery, this);

}).call(this);
