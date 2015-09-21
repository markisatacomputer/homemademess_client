'use strict'

angular.module 'homemademessClient'
.controller 'MainCtrl', ($scope, $http, $stateParams, apiUrl, $mdDialog, $document) ->
  # init view
  $scope.view = {}
  $scope.slide = {}
  
  # which view are we in
  if $stateParams.tag
    getURI = apiUrl + '/tagged/' + $stateParams.tag
    $scope.containerClass = 'tagged'
    $scope.tag = $stateParams.tag.replace '_', ' '
  else
    getURI = apiUrl + '/images'
    $scope.containerClass = 'main'
  
  $http.get(getURI).success (result) ->
    $scope.view.images = result.images
    $scope.view.tags = result.tags
    $scope.view.offset = 0
  
  $scope.keydown = (e) ->
    console.log e
    if e.keyCode
      i = $scope.slide.$index
      switch e.keyCode
        # Left
        when 37
          if i > 0
            $scope.slide = $scope.view.images[i-1]
        # Right
        when 39
          if i < $scope.view.images.length - 1
            $scope.slide = $scope.view.images[i+1]
        # Page Up
        when 33
          if i != 0
            $scope.slide = $scope.view.images[0]
        # Page Down
        when 34
          if i != $scope.view.images.length - 1
            $scope.slide = $scope.view.images[$scope.view.images.length - 1]
      $scope.$apply()

  $scope.showSlide = (slide) ->
    if window.innerWidth > 459
      $scope.slide = $scope.view.images[slide]
      $mdDialog.show {
        clickOutsideToClose: true
        scope: $scope
        preserveScope: true
        template: '<md-dialog aria-label="{{slide.filename}}" class="slide" ng-class="getOrientation()">' +
                      '  <md-dialog-content>' +
                      '     <img src="{{slide.derivative[2].uri}}" class="img-responsive" />' +
                      '  </md-dialog-content>' +
                      '</md-dialog>'
        controller: ($scope, $mdDialog, $document) ->
          $document.on 'keydown', $scope.keydown
          $scope.lastpress = 0
          $scope.getOrientation = () ->
            h = $scope.slide.derivative[2].height
            w = $scope.slide.derivative[2].width
            if h > w
              'portrait'
            else
              'landscape'
      }
