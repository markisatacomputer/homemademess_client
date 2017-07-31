'use strict'

angular.module 'homemademessClient'
.directive 'onLongPress', [ '$timeout', '$parse', ($timeout, $parse) ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    timeoutHandler = ''
    fn = $parse attrs.onLongPress
    delay = if attrs.delay? then attrs.delay else 600

    elem.bind 'touchstart', (event) ->
      scope.longTouchTriggered = false
      timeoutHandler = $timeout ->
        #  prevent other touch handlers
        if scope.longTouchTriggered and event.preventDefault then event.preventDefault()
        #  call callback
        fn scope, {$event: event}
      , delay

    elem.bind 'touchmove', (event) ->
      $timeout.cancel timeoutHandler

    elem.bind 'touchend', (event) ->
      scope.longTouchTriggered = true
      $timeout.cancel timeoutHandler
]