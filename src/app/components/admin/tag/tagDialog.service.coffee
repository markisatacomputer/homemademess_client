'use strict'

tagDialogService = ($resource, apiUrl) ->
  api =  $resource apiUrl + '/select/tags/:id'

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

angular.module 'homemademessClient'
.factory 'tagDialogService', ['$resource', 'apiUrl', tagDialogService]
