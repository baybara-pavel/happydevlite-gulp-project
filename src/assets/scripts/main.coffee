$ = require 'jquery'
# pace = require './vendor/pace.min.js'
cog = require './cog'
hover = require './hover'
random = require './random-opinion'
validation = require './validation'

$(document).ready ->
  animate = undefined
  autoRotate = undefined
  rotate = undefined
  toNext = undefined
  toPrev = undefined
  rotate =
    on: ->
      @timer = setTimeout(autoRotate, 6000)
    off: ->
      clearTimeout @timer
    timer: 0

  animate = (element, active) ->
    activeClass = undefined
    animationTime = undefined
    animationTime = 1500
    activeClass = 'active'
    active.animate { opacity: 0 }, animationTime
    active.removeClass activeClass
    element.animate { opacity: 1 }, animationTime
    element.addClass activeClass

  toNext = ->
    active = undefined
    images = undefined
    next = undefined
    active = $('.js-background .active')
    images = $('.js-background .js-carousel')
    if active.next().length > 0
      next = active.next()
    else
      next = images.first()
    animate next, active

  toPrev = ->
    active = undefined
    images = undefined
    prev = undefined
    active = $('.js-background .active')
    images = $('.js-background .js-carousel')
    if active.prev().length > 0
      prev = active.prev()
    else
      prev = images.last()
    animate prev, active

  autoRotate = ->
    toNext()
    rotate.on()

  $(document).on 'click', '.js-right-arr', ->
    rotate.off()
    toNext()
    rotate.on()
  $(document).on 'click', '.js-left-arr', ->
    rotate.off()
    toPrev()
    rotate.on()
  $('.js-carousel.active').ready ->
    rotate.on()
