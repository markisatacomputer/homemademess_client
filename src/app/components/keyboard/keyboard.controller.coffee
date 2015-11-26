'use strict'

angular.module 'homemademessClient'
.directive 'keyboard', [ '$document', '$rootScope', ($document, $rootScope) ->
  directive =
    restrict: 'A'
    link: (scope, element, attr) ->
      $document.bind 'keyup', (e) ->
        $rootScope.$broadcast 'keyup:'+e.which, e
]
.directive 'keyboardNext', [ ()->
  directive =
    restrict: 'A'
    scope: false
    link: (scope, element, attr) ->
      scope.$on 'keyup:39', (n, e) ->
        if scope.i < scope.slides.length - 1
          scope.i = scope.i+1
          scope.$digest()
]
.directive 'keyboardPrev', [ ()->
  directive =
    restrict: 'A'
    scope: false
    link: (scope, element, attr) ->
      scope.$on 'keyup:37', (n, e) ->
        if scope.i > 0
          scope.i = scope.i-1
          scope.$digest()
]
.directive 'keyboardStart', [ ()->
  directive =
    restrict: 'A'
    scope: false
    link: (scope, element, attr) ->
      scope.$on 'keyup:38', (n, e) ->
        if scope.i != 0
          scope.i = 0
          scope.$digest()
]
.directive 'keyboardEnd', [ ()->
  directive =
    restrict: 'A'
    scope: false
    link: (scope, element, attr) ->
      scope.$on 'keyup:40', (n, e) ->
        if scope.i != scope.slides.length - 1
          scope.i = scope.slides.length - 1
          scope.$digest()
]