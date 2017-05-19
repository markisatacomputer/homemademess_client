'use strict'

angular.module 'homemademessClient'
.factory 'Slides', ($cookies, $resource, apiUrl, $location) ->

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

  authHeader = (headers) ->
    token = $cookies.get 'token'
    if token
      'Bearer ' + token
    else
      ''

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
      headers:
        'Authorization' : authHeader