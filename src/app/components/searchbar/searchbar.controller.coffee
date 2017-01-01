'use strict'

angular.module 'homemademessClient'
.controller 'SearchbarCtrl', [ '$scope', '$resource', '$location', 'apiUrl',
($scope, $resource, $location, apiUrl) ->

  tagsToParam = (tags) ->
    param = ''
    angular.forEach tags, (val, key) ->
      if param.length > 0 then param += '~~'
      param += val.text.replace /\s/g, '_'
    param

  $scope.$watchCollection 'view.filter.tag.tags', (newTags, oldTags, equals) ->
    if newTags != undefined and newTags.length > 0
      p = tagsToParam newTags
      $location.search 'tags', p
    else
      if oldTags != undefined and oldTags.length > 0 and newTags.length == 0
        $location.search 'tags', null

  #  Autocomplete
  Auto = $resource apiUrl + '/auto'
  $scope.findTags = (value) ->
    return Auto.query({q:value}).$promise

  $scope.tagRemoved = (tag) ->
    console.log tag
]
