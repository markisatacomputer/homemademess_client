'use strict'

angular.module 'homemademessClient'
.factory 'tagDialogService', (Auth, $resource, apiUrl) ->
  api =  $resource apiUrl + '/select/tags/:id'

  tagDialogService =
    get: ->
      api.get (t) ->
        return t
      , (e) ->
        console.log e
      .$promise

    add: (tags) ->
      api.save tags, (t) ->
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
