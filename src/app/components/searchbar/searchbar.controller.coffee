'use strict'

angular.module 'homemademessClient'
.directive 'searchbar', ->
  searchbarCtrl = [ '$scope', '$resource', '$location', 'apiUrl', 'Slides',
  ($scope, $resource, $location, apiUrl, Slides) ->
    #  Map tags to simple array
    tagsToParam = (tags) ->
      param = ''
      angular.forEach tags, (val, key) ->
        if param.length > 0 then param += '~~'
        param += val.text.replace /\s/g, '_'
      param

    #  Autocomplete
    Auto = $resource apiUrl + '/auto'
    $scope.findTags = (value) ->
      return Auto.query({q:value}).$promise

    #  update params and scope on tags update
    $scope.updateTagParam = (tag) ->
      if $scope.tags.length > 0
        $location.search 'tags', tagsToParam $scope.tags
      else
        $location.search 'tags', null
      Slides.get {},
        (s) ->
          $scope.view = s
        (e) ->
          console.log e
  ]
  directive =
    restrict: 'E'
    controller: searchbarCtrl
    templateUrl: 'app/components/searchbar/searchbar.html'