# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.tweets-per-minute')
  new Chartkick.ColumnChart 'tweets-per-minute', '/home/tweets_per_minute',
    library:
      xAxis:
        labels:
          step: 80


$(document).ready ready
$(document).on 'page:load', ready
