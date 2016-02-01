'use strict'

angular.module 'homemademessClient'
.directive 'searchbar', ->

  SearchCtrl =  [ '$scope', '$resource', 'apiUrl', ($scope, $resource, apiUrl) ->
    #  Autocomplete
    Auto = $resource apiUrl + '/auto'
    $scope.findTags = (value) ->
      return Auto.query({q:value}).$promise
  ]

  directive =
    restrict: 'E'
    templateUrl: 'app/components/searchbar/searchbar.html'
    controller: SearchCtrl
