$ = require 'jquery'
hoverOn = (element) ->
  $(element).addClass 'share-hovered'
  $(element).find('.js-hide-on-hover').addClass 'hided'
  $(element).find('.js-show-on-hover').addClass 'inline'
  return

hoverOff = (element) ->
  $(element).removeClass 'share-hovered'
  $(element).find('.js-hide-on-hover').removeClass 'hided'
  $(element).find('.js-show-on-hover').removeClass 'inline'
  return

if !('ontouchstart' in document)
  $('.js-tw-hover').hover (->
    hoverOn this
    return
  ), ->
    hoverOff this
    return
  $('.js-vk-hover').hover (->
    hoverOn this
    return
  ), ->
    hoverOff this
    return
  $('.js-fb-hover').hover (->
    hoverOn this
    return
  ), ->
    hoverOff this
    return
else
  #off hover effect for touchscreen devices
  hoverOn '.js-share-for-touch'
return