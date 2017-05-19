'use strict'

angular.module 'homemademessClient'
.factory 'tagDialogService', (Auth, $resource, apiUrl) ->

  headers = Auth.addHeader()

  api =  $resource apiUrl + '/select/tags/:id',
    {},
    get:
      method: 'GET'
      headers: headers
    post:
      method: 'POST'
      headers: headers
    delete:
      method: 'DELETE'
      headers: headers

  tagDialogService =
    get: ->
      api.get (t) ->
        return t
      , (e) ->
        console.log e
      .$promise

    add: (tags) ->
      api.post tags, (t) ->
        return t
      , (e) ->
        console.log e
      .$promise

    remove: (tagid) ->
      api.delete {id: tagid}, (t) ->
        return t
      , (e) ->
        console.log e
      .$promise
