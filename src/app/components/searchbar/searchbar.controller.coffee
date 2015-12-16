'use strict'

angular.module 'homemademessClient'
.directive 'searchbar', ->

  SearchCtrl =  [ '$scope', '$resource', 'lodash', '$q', 'apiUrl', '$state',
  ($scope, $resource, lodash, $q, apiUrl, $state) ->
    $scope.searchText = null
    $scope.selectedItem = null

    $scope.transformChip = (chip) ->
      console.log 'chip', chip
    #  Map tags to simple array
    $scope.mapTags = (tags) ->
      # return an array of unique values
      lodash.uniq lodash.map tags, '_id'
    
    #  Action to take when tags change
    Images = $resource apiUrl + '/images'
    $scope.redoSearch = () ->
      console.log 'redoSearch', $scope.tags
      Images.get { tags: $scope.mapTags $scope.tags }, (result) ->
        $scope.view.images = result.images

    #  Autocomplete
    Auto = $resource apiUrl + '/auto'
    $scope.findTags = (value) ->
      Auto.query {q:value}, (result) ->
        result
  ]

  directive =
    restrict: 'E'
    templateUrl: 'app/components/searchbar/searchbar.html'
    controller: SearchCtrl
