'use strict'

angular.module 'homemademessClient'
.factory 'Slides', ($resource, apiUrl, $location) ->

  #  get query param and return value -> default value -> null
  getParam = (q, defaultVal) ->
    filter = $location.search()
    if filter[q]?
      filter[q]
    else
      if defaultVal?
        defaultVal
      else
        null

  $resource apiUrl + '/images',
    #  all the query params for our api call
    page:    ()->
      getParam 'page', 0
    per:     ()->
      getParam 'per',  60
    tagtext: ()->
      getParam 'tagtext'
  ,
    #  our only method for the moment
    get:
      method: 'GET'
