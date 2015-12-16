'use strict'

angular.module 'homemademessClient'
.controller 'MainCtrl', ['$scope', '$state', 'slides', ($scope, $state, slides) ->
  # init view
  $scope.view = slides.data
  $scope.tags = []

  # broadcast view content complete for child directives
  $scope.$on '$viewContentLoaded', (event) ->
    $scope.$broadcast 'viewInit', $state.params
  
  $scope.aspect = (img,n) ->
    #  Get aspect ratio as decimal
    a = Math.round((img.width/img.height)*100)/100
    #  There's a few different cases of how to proceed
    #  if ratio is less than 1 - portrait
    if (a < 1)
      columns = switch
        when a < 0.5 then 8
        when a < 0.25 then 6
        when a < 0.25 then 4
        else 12
      rows = Math.round columns*img.height/img.width
    #  if ratio > 1 - landscape
    else
      rows = switch
        when a > 1.51 then 12
        when a > 2 then 16
        when a > 3 then 24
        else 8
      columns = Math.round rows*a
    aspect = [columns, rows]
    aspect[n]
]