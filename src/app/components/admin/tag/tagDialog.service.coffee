'use strict'

angular.module 'homemademessClient'
.factory 'tagDialogService', (Auth, $resource, apiUrl) ->

  headers = Auth.addHeader()

  api =  $resource apiUrl + '/select/tags',
    {},
    get:
      method: 'GET'
      headers: headers

    put:
      method: 'POST'
      headers: headers


  tagDialogService =
    get: ->
      api.get (t) ->
        return t
      , (e) ->
        console.log e
      .$promise

    add: (tags) ->
      api.put tags, (t) ->
        return t
      , (e) ->
        console.log e
      .$promise
