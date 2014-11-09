# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  # Because Chartkick requires an ID on the div where the chart is being inserted
  for panel_id in ['left-panel', 'right-panel', 'bottom-row-1', 'bottom-row-2']
    for element, i in $("##{panel_id} .panel-wrapper .stage")
      $(element).attr 'id', "#{panel_id}-stage-#{i + 1}"

  $('#main-panel .panel-wrapper .stage').attr 'id', 'main-panel-stage'


  place_chart = (title, type, id, metric, options = {}) ->
    $('#' + id).siblings('.title').text(title)

    if options.onclick
      options = $.extend options,
                          library:
                            plotOptions:
                              series:
                                point:
                                  events:
                                    click: (event) ->
                                      options.onclick this.category, this.y
                            chart:
                              events:
                                load: ->
                                  $("##{id} .highcharts-axis-labels text").click ->
                                    options.onclick $(this).text()



    new Chartkick[type + 'Chart'] id, "/dashboard/data/#{metric}", options

  user_click_fn = (label, value) -> window.location.href = "/users/#{label}"
  tweet_click_fn = (label, value) -> window.location.href = "/tweets/#{label}"


  place_chart 'Top Tweeters', 'Bar', 'left-panel-stage-1', 'top_tweeters', onclick: user_click_fn

  place_chart 'Top Retweeters', 'Bar', 'left-panel-stage-2', 'top_retweeters', onclick: user_click_fn

  place_chart 'Original Tweets Over Time', 'Column', 'main-panel-stage', 'original_tweets_over_time',
    library:
      xAxis:
        labels:
          step: 80

  place_chart 'Most Favorited Tweets', 'Bar', 'right-panel-stage-1', 'most_favorited_tweets', onclick: tweet_click_fn

  place_chart 'Most Retweeded Tweets', 'Bar', 'right-panel-stage-2', 'most_retweeted_tweets', onclick: tweet_click_fn


$(document).ready ready
$(document).on 'page:load', ready
