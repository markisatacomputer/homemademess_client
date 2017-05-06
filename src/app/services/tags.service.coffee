'use strict'

angular.module 'homemademessClient'
.factory 'Tags', ($resource, apiUrl, $location) ->

  #  get query param and return value -> default value -> null
  getTags = () ->
    filter = $location.search()
    if filter.tagtext?
      filter.tagtext
    else
      []

  $resource apiUrl + '/tags',
    #  all the query params for our api call
    text: () ->
      getTags()
  ,
    #  our only method for the moment
    get:
      method: 'GET'
      isArray: true
