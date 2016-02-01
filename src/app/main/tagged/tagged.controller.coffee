'use strict'

angular.module 'homemademessClient'
.controller 'TaggedCtrl', ['$scope', '$stateParams', '$http', 'apiUrl', ($scope, $stateParams, $http, apiUrl) ->
  # init view
  $scope.tag = $stateParams.tag.replace /_/g, ' '

  tags = $scope.view.filter.tag.tags
  #  remove additional tags
  if tags.length > 1
    angular.forEach tags, (tag, key) ->
      if tag.text != $scope.tag
        $scope.view.filter.tag.tags.splice key, 1
  #  set the filter if it isn't already
  if tags.length is 0
    $http.get apiUrl + '/tags?text='  + $stateParams.tag
    .then (res) ->
      $scope.view.filter.tag.tags = res.data

]