'use strict'

angular.module 'homemademessClient'
.controller 'MainCtrl', [
  '$scope', '$state', 'slides', '$resource', 'lodash', 'apiUrl',
  ($scope, $state, slides, $resource, lodash, apiUrl) ->
    # init view
    $scope.view = slides
    $scope.view.filter =
      tag:
        tags: []
        logic: ['and', 'or', 'not']
        operator: 'and'
      date:
        max: 0
        min: 0

    #  Map tags to simple array
    mapTags = (tags) ->
      # return an array of unique values
      lodash.uniq lodash.map tags, '_id'
    
    #  Action to take when tags change
    Images = $resource apiUrl + '/images'
    $scope.$watchCollection 'view.filter.tag.tags', (newTags) ->
      Images.get { tags: mapTags newTags, logic: $scope.view.filter.tag.operator }, (result) ->
        $scope.view.images = result.images
        $scope.view.tags = result.tags

    # broadcast view content complete for child directives
    $scope.$on '$viewContentLoaded', (event) ->
      $scope.$broadcast 'viewInit', $state.params
]