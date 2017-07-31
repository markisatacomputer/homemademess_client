'use strict'

touchService = ($cookies, broadcastService) ->
  touchService =
    store: (touch) ->
      if touch
        $cookies.put 'touch', 1
      else
        $cookies.put 'touch', null

    get: ->
      $cookies.get 'touch'

angular.module 'homemademessClient'
.factory 'touchService', ['$cookies', 'broadcastService', touchService]