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
			requiredClass: 'required'
			emailName: 'email'
		settings = $.extend({}, defaults, options)
		
		pattern = /^.+@.+[.].{2,}$/i
		required_length = 0
		$form = null
		
		checkInput = ($form,$required)->
			$field = if $required.is('input,textarea') then $required else $required.find('input,textarea')
			
			$field.on 'keyup change input propertychange', (e)->
				# Block submit on enter
				if e.keyCode is 13 then e.preventDefault()
				if $field.val().length >= 2
					$required.addClass('aVALIDATE_passed')
					if $field.is('[name='+settings.emailName+']') and not runReg $field.val()
						$required.removeClass('aVALIDATE_passed')
				else
					$required.removeClass('aVALIDATE_passed')
				checkValidation()

		checkEmail = ()->
			$email = $form.find '[name='+settings.emailName+']'
			
			$form.append '<div id="emailInfo" class="info">&#8226</div>'
			
			$info = $("#emailInfo")
			position = $email.position()
			$info.css
				top: position.top + 4
				left: position.left + $email.width() + 24
				position: 'absolute'
				color: '#FF0000'
			
			$email.keyup (e)->
				if e.keyCode is 13 then e.preventDefault()
				clr = '#FF0000'
				if runReg $email.val()
					$email.addClass('aVALIDATE_passed')
					checkValidation()
				else
					$email.removeClass('aVALIDATE_passed')
				$info.css
					color: clr

		runReg = (string)->
			pattern.test string
		
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
			
			required_length = $form.find('.'+settings.requiredClass).length
			checkValidation()
			
			$form.find(".required").each ()->
				$this = $(this)
				checkInput($form,$this)

) jQuery, this
