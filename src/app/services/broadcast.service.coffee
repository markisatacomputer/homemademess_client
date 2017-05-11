'use strict'

angular.module 'homemademessClient'
.factory 'broadcastService', ($rootScope, debug) ->
  send: ->
    #  convert args to array
    args = if arguments.length is 1 then [arguments[0]] else Array.apply null, arguments
    #  broadcast
    $rootScope.$broadcast.apply $rootScope, args
    #  debug
    if debug then console.log.apply $rootScope, args