angular.module 'homemademessClient', [
  'ngAria'
  'ngResource'
  'ui.router'
  'ngMaterial'
  'ngTagsInput'
  'ngLodash'
]
.filter 'taglink', () ->
  (input) ->
    input.replace /\s/g, '_'