'use strict'

Slides = ($resource, apiUrl, $location) ->

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

  $resource apiUrl + '/images/:id',
    #  all the query params for our api call
    page:    ()->
      getParam 'page', 0
    per:     ()->
      getParam 'per',  60
    tagtext: ()->
      getParam 'tagtext'
    start: ()->
      getParam 'start'
    end: ()->
      getParam 'end'
    up: ()->
      getParam 'up'
    selected: ()->
      getParam 'selected'
    order: ()->
      getParam 'order'
    id: @id
  ,
    'get':
      method: 'GET'
    'save':
      method: 'POST'
    'query':
      method: 'GET'
      isArray: true
    'delete':
      method: 'DELETE'
    'update':
      method: 'PUT'

angular.module 'homemademessClient'
.factory 'Slides', ['$resource', 'apiUrl', '$location', Slides]
