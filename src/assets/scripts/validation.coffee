$ = require 'jquery'

email = $('.js-email')
validationResult = $('.js-validation-result')
fildDanger = 'has-danger'
fildWarning = 'has-warning'
textDanger = 'text-danger'
textWarning = 'text-warning'
textDone = 'text-done'
$(document).on 'focus', '.js-email', ->
  validationResult.text ''
  email.val ''
  email.removeClass textDanger
  email.removeClass fildDanger
  email.removeClass textWarning
  email.removeClass fildWarning
  email.removeClass textDone
  return
$(document).on 'click', '.js-submit', ->
  emailValue = email.val()
  if emailValue != ''
    regExp = /.+@.+\..+/i
    if regExp.test(emailValue)
      email.removeClass fildDanger
      email.removeClass textDanger
      $.ajax
        url: ''
        data: 'entry.1926142699': emailValue
        type: 'POST'
        dataType: 'xml'
        statusCode:
          0: ->
            #Success message
            validationResult.text 'Ура! Подписка оформлена!'
            validationResult.addClass textDone
            email.val ''
            return
          200: ->
            #Success Message
            return
    else
      validationResult.text 'Некорректный e-mail'
      validationResult.addClass textDanger
      email.addClass textDanger
      email.addClass fildDanger
  else
    validationResult.text 'Поле не заполнено.. Ай-я-яй..'
    validationResult.addClass textWarning
    email.addClass fildWarning
  return