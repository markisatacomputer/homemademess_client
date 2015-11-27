'use strict'

angular.module 'homemademessClient'
.controller 'MainCtrl', ($scope, $http, $stateParams, apiUrl, $mdDialog, $document) ->
  # init view
  $scope.view = {}
  $scope.i = 0

  # watch slide index for changes and update slide object
  ###$scope.$watch 'i', (v, old) ->
    console.log 'i change', old, v
    $scope.slide = $scope.view.images[v]###
  
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
  
  $scope.aspect = (img,n) ->
    #  Get aspect ratio as decimal
    a = Math.round((img.width/img.height)*100)/100
    #  There's a few different cases of how to proceed
    #  if ratio is less than 1 taller than wide
    if (a < 1)
      columns = switch
        when a < 0.5 then 8
        when a < 0.25 then 6
        when a < 0.25 then 4
        else 12
      rows = Math.round columns*img.height/img.width
    #  if ratio > 1 wider than tall
    else
      rows = switch
        when a > 1.51 then 12
        when a > 2 then 16
        when a > 3 then 24
        else 8
      columns = Math.round rows*a
    aspect = [columns, rows]
    # console.log aspect, a, img.height/img.width
    aspect[n]

  $scope.showSlide = (slide) ->
    if window.innerWidth > 459
      # store slide index
      locals =
        i: Number slide
        slides: $scope.view.images
      $mdDialog.show {
        clickOutsideToClose: true
        locals: locals,
        template: '<md-dialog aria-label="{{slide.filename}}" class="slide">' +
                  '  <md-dialog-content keyboard-next keyboard-prev keyboard-start keyboard-end>' +
                  '     <img ng-src="{{img}}" class="img-responsive" ng-style="{{stylez}}" />' +
                  '  </md-dialog-content>' +
                  '</md-dialog>'
        controller: ($scope, $mdDialog, i, slides) ->
          $scope.slides = slides
          $scope.i = i
          $scope.img

          # watch slide index for changes and update slide object
          $scope.$watch 'i', (v, old) ->
            $scope.img = $scope.slides[v].derivative[2].uri
      }
