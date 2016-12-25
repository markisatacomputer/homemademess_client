angular.module 'homemademessClient', [
  'ngAria'
  'ngResource'
  'ngCookies'
  'ui.router'
  'ngMaterial'
  'ngTagsInput'
  'hmTouchEvents'
  'ngLodash'
  'debounce'
]
.filter 'taglink', () ->
  (input) ->
    input.replace /\s/g, '_'