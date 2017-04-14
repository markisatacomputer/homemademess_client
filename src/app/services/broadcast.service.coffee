'use strict'

angular.module 'homemademessClient'
.factory 'broadcastService', ($rootScope, debug) ->
  send: (msg, data) ->
    $rootScope.$broadcast msg, data
    if debug then console.log msg, data