(($, window, undefined_) ->

	$.fn.validate = (options)->

		$styles = $('
		    <style id="aVALIDATE_styles">
		    	[required] {
		    		position: relative;
		    	}
		        [required]:after {
		        	content: " \\002a";
					color: #F00;
		        }
		        .aVALIDATE_passed:after {
		        	color: #0F0;
		        }
		    </style>
	    ')
		
		defaults =
			requiredSelector: '.required,[required="required"]'
			emailName: 'email'
		settings = $.extend({}, defaults, options)
		
		email_pattern = /^.+@.+[.].{2,}$/i
		required_length = 0
		$form = null
		
		checkInput = ($form,$required)->
			$field = if $required.is('input,textarea') then $required else $required.find('input,textarea')
			
			$field.on 'keyup change input propertychange', (e)->
				# Block submit on enter
				if e.keyCode is 13 then e.preventDefault()
				# Check type
				switch $field.attr('type')
					when 'file'
						passed = false
						files = $field[0].files
						accept = $field.attr 'accept'
						max_size = $field.data('max-size') * 1024 * 1024 # MB to bytes
						for file in files
							console.log file
							if accept
								if accept.indexOf '/'
									if accept is file.type
										passed = true
								else
									extension = '.'+file.name.split('.').pop()
									if accept.indexOf extension
										passed = true
							if max_size
								passed = false
								if parseInt(max_size) > file.size
									passed = true
						if passed then $required.addClass('aVALIDATE_passed')
					else
						if $field.val().length >= 2
							$required.addClass('aVALIDATE_passed')
							if $field.is('[name='+settings.emailName+']') and not runReg $field.val()
								$required.removeClass('aVALIDATE_passed')
						else
							$required.removeClass('aVALIDATE_passed')
				checkValidation()

		runReg = (string)->
			email_pattern.test string
		
		checkValidation = ()->
			$submit = $form.find(":submit")
			if required_length is $form.find(".aVALIDATE_passed").length
				$submit.removeAttr('disabled').css
					opacity: 1
			else
				$submit.attr('disabled','disabled').css
					opacity: .24

		@each ->
			if $('style#aVALIDATE_styles').length is 0 then $('head').append($styles)

			$form = $(this)
			
			required_length = $form.find(settings.requiredSelector).length
			checkValidation()
			
			$form.find(settings.requiredSelector).each ()->
				$this = $(this)
				checkInput($form,$this)

) jQuery, this
