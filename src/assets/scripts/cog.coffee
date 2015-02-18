$ = require 'jquery'
$(window).on 'load', ->
  $('.js-loader-icon').removeClass('spinning-cog').addClass('shrinking-cog')
  $('.js-loader-background').delay(750).fadeOut( ->
    $('.js-loader').delay(1300).fadeOut().hide()
    )