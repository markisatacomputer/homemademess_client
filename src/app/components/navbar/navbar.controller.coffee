'use strict'

angular.module 'homemademessClient'
.controller 'NavbarCtrl', ($scope, $resource, lodash, $q, $location, apiUrl) ->
  $scope.tags = []

  $scope.isActive = (route) ->
    #console.log $location.path()
    route is $location.path()

  #  Map tags to simple array
  $scope.mapTags = (tags) ->
    # return an array of unique values
    lodash.uniq lodash.map tags, '_id'
  
  #  Action to take when tags change
  Images = $resource apiUrl + '/images'
  $scope.redoSearch = () ->
    Images.get { tags: $scope.mapTags $scope.tags }, (result) ->
      $scope.view.images = result.images

  #  Autocomplete
  Auto = $resource apiUrl + '/auto'
  $scope.findTags = (value) ->
    return Auto.query({q:value}).$promise
