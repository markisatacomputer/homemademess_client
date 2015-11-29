'use strict'

angular.module 'homemademessClient'
.directive 'keyboard', [ '$document', '$rootScope', ($document, $rootScope) ->
  directive =
    restrict: 'A'
    link: (scope, element, attr) ->
      $document.bind 'keyup', (e) ->
        msg = switch e.which
          when 39 then 'next'
          when 37 then 'prev'
          when 38 then 'start'
          when 40 then 'end'
          else false
        if msg != false
         $rootScope.$broadcast 'keyup:'+ msg, e
]