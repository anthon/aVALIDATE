// Generated by CoffeeScript 1.10.0
(function() {
  (function($, window, undefined_) {
    return $.fn.validate = function(options) {
      var $form, $styles, checkInput, checkValidation, defaults, email_pattern, required_length, runReg, settings;
      $styles = $('<style id="aVALIDATE_styles"> .required { position: relative; } .required:after { content: " \\002a"; color: #F00; } .aVALIDATE_passed:after { color: #0F0; } </style>');
      defaults = {
        requiredSelector: '.required',
        emailName: 'email'
      };
      settings = $.extend({}, defaults, options);
      email_pattern = /^.+@.+[.].{2,}$/i;
      required_length = 0;
      $form = null;
      checkInput = function($form, $req) {
        var $field, $required;
        $required = $req;
        $field = $required.is('input,textarea') ? $required : $required.find('input,textarea');
        return $field.on('keyup change input propertychange', function(e) {
          var accept, extension, file, files, i, len, max_size_bytes, max_size_mb, passed;
          if (e.keyCode === 13) {
            e.preventDefault();
          }
          passed = false;
          console.log($field);
          switch ($field.attr('type')) {
            case 'file':
              files = $field[0].files;
              console.log(files);
              accept = $field.attr('accept');
              max_size_mb = parseInt($field.data('max-size'));
              for (i = 0, len = files.length; i < len; i++) {
                file = files[i];
                console.log(file);
                passed = false;
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
                if (max_size_mb) {
                  passed = false;
                  max_size_bytes = max_size_mb * 1024 * 1024;
                  console.log(max_size_bytes);
                  console.log(file.size);
                  if (max_size_bytes > file.size) {
                    passed = true;
                  }
                  console.log(passed);
                }
              }
              break;
            default:
              if ($field.val().length >= 2) {
                passed = true;
                if ($field.is('[name=' + settings.emailName + ']') && !runReg($field.val())) {
                  passed = false;
                }
              } else {
                passed = false;
              }
          }
          if (passed) {
            $required.addClass('aVALIDATE_passed');
          } else {
            $required.removeClass('aVALIDATE_passed');
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
