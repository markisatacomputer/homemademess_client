'use strict'

Auto = ($resource, apiUrl) ->
  $resource apiUrl + '/auto'

angular.module 'homemademessClient'
.factory 'Auto', ['$resource', 'apiUrl', Auto]