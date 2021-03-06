(($, window, undefined_) ->

	$.fn.validate = (options)->

		$styles = $('
		    <style id="aVALIDATE_styles">
		    	.required {
		    		position: relative;
		    	}
		        .required:after {
		        	content: " \\002a";
					color: #F00;
		        }
		        .aVALIDATE_passed:after {
		        	color: #0F0;
		        }
		    </style>
	    ')
		
		defaults =
			requiredSelector: '.required'
			emailName: 'email'
		settings = $.extend({}, defaults, options)
		
		email_pattern = /^.+@.+[.].{2,}$/i
		required_length = 0
		$form = null
		
		checkInput = ($form,$req)->
			$required = $req
			$field = if $required.is('input,textarea') then $required else $required.find('input:not([type="hidden"]),textarea')
			
			$field.on 'keyup change input propertychange', (e)->
				# Block submit on enter
				if e.keyCode is 13 then e.preventDefault()
				passed = false
				# Check type
				switch $field.attr('type')
					when 'file'
						files = $field[0].files
						# console.log files
						accept = $field.attr 'accept'
						max_size_mb = parseInt $field.data('max-size')
						for file in files
							# console.log file
							if accept
								passed = false
								if accept.indexOf('/') isnt -1
									if accept is file.type
										passed = true
								else
									extension = '.'+file.name.split('.').pop()
									# console.log accept
									# console.log extension
									# console.log accept.indexOf(extension)
									if accept.indexOf(extension) isnt -1
										console.log 'Passed?'
										passed = true
							if max_size_mb
								passed = false
								max_size_bytes = max_size_mb * 1024 * 1024 # MB to bytes
								# console.log max_size_bytes
								# console.log file.size
								if max_size_bytes > file.size
									passed = true
								# console.log passed
					else
						if $field.val().length >= 2
							passed = true
							if $field.is('[name='+settings.emailName+']') and not runReg $field.val()
								passed = false
						else
							passed = false
				if passed
					$required.addClass('aVALIDATE_passed')
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
					opacity: .72

		@each ->
			if $('style#aVALIDATE_styles').length is 0 then $('head').append($styles)

			$form = $(this)
			
			required_length = $form.find(settings.requiredSelector).length
			checkValidation()
			
			$form.find(settings.requiredSelector).each ()->
				$this = $(this)
				checkInput($form,$this)

) jQuery, this
