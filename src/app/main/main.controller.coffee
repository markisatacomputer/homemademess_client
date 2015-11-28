'use strict'

angular.module 'homemademessClient'
.controller 'MainCtrl', ($scope, $http, $stateParams, apiUrl, $state, $document) ->
  # init view
  $scope.view = {}
  $scope.i = 0
  
  # which view are we in
  if $stateParams.tag
    getURI = apiUrl + '/tagged/' + $stateParams.tag
    $scope.containerClass = 'tagged'
    $scope.tag = $stateParams.tag.replace /_/g, ' '
  else
    getURI = apiUrl + '/images'
    $scope.containerClass = 'main'
  
  $http.get(getURI).success (result) ->
    $scope.view.images = result.images
    $scope.view.tags = result.tags
    $scope.view.offset = 0
    # if someone has navigated to an open slide, open it
    console.log $stateParams, $scope
    if $stateParams.slide
      console.log 'bla'
      $scope.i = Number $stateParams.slide
      #console.log angular.element($document).find('a[open-slide="'+$scope.i+'"]').triggerHandler 'click'
      $scope.showSlide {i: $scope.i}
  
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
