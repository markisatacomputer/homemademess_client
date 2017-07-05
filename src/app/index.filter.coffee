angular.module 'homemademessClient'
.filter 'taglink', () ->
  (input) ->
    input.replace /\s/g, '_'
