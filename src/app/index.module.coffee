angular.module 'homemademessClient', [
  'ngAria'
  'ngResource'
  'ui.router'
  'ngMaterial'
  'ngTagsInput'
  'hmTouchEvents'
  'ngLodash'
]
.filter 'taglink', () ->
  (input) ->
    input.replace /\s/g, '_'