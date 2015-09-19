angular.module 'homemademessClient', [
  'ngCookies'
  'ngSanitize'
  'ngAria'
  'ngResource'
  'ui.router'
  'akoenig.deckgrid'
  'ngMaterial'
  'ngDropzone'
  'ngTagsInput'
  'ngLodash'
]
.filter 'taglink', () ->
  (input) ->
    input.replace /\s/g, '_'