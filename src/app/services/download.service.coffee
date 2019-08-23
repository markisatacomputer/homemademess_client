'use strict'

Download = ($resource, apiUrl) ->
  $resource apiUrl + '/file/:id',
    #  all the query params for our api call
    {id: @id}
  ,
    one:
      method: 'GET'
      cache: false
      transformResponse: (data, headers) ->
        response: data
    many:
      method: 'POST'
      transformResponse: (data, headers) ->
        response: data


angular.module 'homemademessClient'
.factory 'Download', ['$resource', 'apiUrl', Download]
