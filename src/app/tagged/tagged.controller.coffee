'use strict'

angular.module 'homemademessClient'
.controller 'TaggedCtrl', ['$scope', 'view', 'user', 'tag',
($scope, view, user, tag) ->

  # init view
  $scope.view = view
  $scope.user = user
  $scope.tag = tag  #$stateParams.tag.replace /_/g, ' '

]