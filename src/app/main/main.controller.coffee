'use strict'

angular.module 'homemademessClient'
.controller 'MainCtrl', [
  '$scope', '$location', 'view', 'user', 'tgs', 'Slides', 'Tags',
  ($scope, $location, view, user, tgs, Slides, Tags) ->
    # init view
    $scope.view = view
    # add user
    $scope.view.user = user
    # filters start hidden
    $scope.showFilters = false
    # populate tags for searchbar
    $scope.tags = tgs


    #  watch query params
    $scope.$watch () ->
      $location.search()
    , (newSearch, oldSearch) ->
      if !angular.equals newSearch, oldSearch
        Slides.get {},
          (s) ->
            $scope.view = s
          (e) ->
            console.log e
        if $location.search().tags?
          Tags.get {},
            (t) ->
              $scope.tags = t
            (e) ->
              console.log e
]