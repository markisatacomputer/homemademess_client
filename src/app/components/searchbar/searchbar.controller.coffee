'use strict'

angular.module 'homemademessClient'
.controller 'SearchCtrl', [
  '$scope', '$resource', 'apiUrl',
  ($scope, $resource, apiUrl) ->
    #  Autocomplete
    Auto = $resource apiUrl + '/auto'
    $scope.findTags = (value) ->
      return Auto.query({q:value}).$promise
]
