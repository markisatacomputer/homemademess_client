'use strict'

angular.module 'homemademessClient'
.controller 'MainCtrl', ['$scope', '$state', '$window', 'slides', ($scope, $state, $window, slides) ->
  # init view
  $scope.view = slides.data
  $scope.tags = []

  # broadcast view content complete for child directives
  $scope.$on '$viewContentLoaded', (event) ->
    $scope.$broadcast 'viewInit', $state.params
]