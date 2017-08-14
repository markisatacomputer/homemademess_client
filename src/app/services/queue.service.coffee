'use strict'

queueService = ($resource, apiUrl) ->
  api =  $resource apiUrl + '/up',
    {id: @id},
    get:
      method: 'GET'

  queueService =
    get: ->
      ctrl = this
      api.get (q) ->
        ctrl.q = q
      , (e) ->
        console.log e
      .$promise

  queueService

angular.module 'homemademessClient'
.factory 'queueService', ['$resource', 'apiUrl', queueService]
