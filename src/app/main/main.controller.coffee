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
    a = Math.round((img.height/img.width)*100)/100
    #  There's a few different cases of how to proceed
    #  if ratio is less than 1 - portrait
    if (a < 1)
      columns = switch
        when a < 0.6 then 8
        when a < 0.4 then 6
        when a < 0.25 then 4
        else 12
      rows = Math.round columns*a
    #  if ratio > 1 - landscape
    else
      rows = switch
        when a > 1.34 then 16
        when a > 2 then 24
        when a > 3 then 36
        else 12
      columns = (Math.round( Math.round(rows*img.width/img.height)/2 ) ) * 2
    aspect = [columns, rows]
    aspect[n]
]