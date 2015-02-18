$ = require 'jquery'
getRandom = (arr, n) ->
  result = new Array(n)
  len = arr.length
  taken = new Array(len)
  if n > len
    throw new RangeError('getRandom: more elements taken than available')
  while n--
    x = Math.floor(Math.random() * len)
    result[n] = arr[if x in taken then taken[x] else x]
    taken[x] = --len
  result

$(document).ready ->
  opinions = $('.js-opinion')
  randomOpinions = getRandom(opinions, 2)
  i = 0
  while i < randomOpinions.length
    $(randomOpinions[i]).removeClass 'hide'
    i++
  # $('.js-content').readmore({
  #   speed: 500,
  #   moreLink: '<a href="">Показать полностью</a>',
  #   lessLink: '<a href="">Скрыть</a>'
  # });
  # console.log(opinions);
  # console.log(randomOpinions);
  return