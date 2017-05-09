'use strict'

angular.module 'homemademessClient'
.factory 'Auto', ($resource, apiUrl) ->
  $resource apiUrl + '/auto'
