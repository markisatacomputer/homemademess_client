'use strict'

angular.module 'homemademessClient'
.factory 'broadcastService', ($rootScope) ->
  send: (msg, data) ->
    $rootScope.$broadcast msg, data