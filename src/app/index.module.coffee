angular.module 'homemademessClient', [
  'ngCookies'
  'ngSanitize'
  'ngAria'
  'ngResource'
  'ui.router'
  'ngMaterial'
  'ngDropzone'
  'ngLodash'
]
.filter 'taglink', () ->
  (input) ->
    input.replace /\s/g, '_'