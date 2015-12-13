'use strict'

angular.module 'homemademessClient'
.controller 'TaggedCtrl', ['$scope', '$stateParams', 'slides', ($scope, $stateParams, slides) ->
  # init view
  $scope.$parent.view = slides.data
  $scope.tag = $stateParams.tag.replace /_/g, ' '
]