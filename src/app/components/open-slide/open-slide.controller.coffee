'use strict'

angular.module 'homemademessClient'
.directive 'openSlide', [ '$document', '$rootScope', ($document, $rootScope) ->
  directive =
    restrict: 'A'
    link: (scope, element, attr) ->
      element.on 'click', (event) ->
        event.preventDefault()
        scope.showSlide attr.openSlide
]
