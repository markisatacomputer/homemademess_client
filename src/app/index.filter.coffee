angular.module 'homemademessClient'
.filter 'taglink', () ->
  (input) ->
    input.replace /\s/g, '_'
.filter 'fromUTC', () ->
  (input, form) ->
    moment(input).format(form)
