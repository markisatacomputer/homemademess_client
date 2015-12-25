angular.module 'homemademessClient'
.controller 'IndexCtrl', ['$scope', '$window', ($scope, $window) ->
  $scope.bodyClass = {}
  
  # body classes
  detectSmall = ()->
    if $window.innerWidth < 600
      return true
    false
  # store in scope
  $scope.bodyClass.small = detectSmall()
  # watch resize and update classes
  angular.element($window).bind 'resize', ()->
    $scope.bodyClass.small = detectSmall()
]