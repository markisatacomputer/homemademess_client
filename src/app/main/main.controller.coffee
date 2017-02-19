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
    $scope.view.filter.tag.tags = tgs

    #  set slides to fit filter
    updateView = (filter) ->
      params = getParamsObject filter
      Slides.get params,
        (s) ->
          $scope.view = s
        (e) ->
          console.log e

    #  set browser query params
    updateParams = (filter) ->
      params = getParamsObject filter
      angular.forEach params, (param, i) ->
        $location.search i, param

    #  get params from filter
    getParamsObject = (filter) ->
      params = {}
      if typeof filter is 'object'
        params.tagtext = if filter.tag.tagtext.length > 0 then tagsToParam filter.tag.tagtext else null
        params.page = if filter.pagination.page > 0 then filter.pagination.page else null
        params.per = if filter.pagination.per != 60 then filter.pagination.per else null
      params

    #  Map tags to simple array
    tagsToParam = (tags) ->
      param = ''
      angular.forEach tags, (val, key) ->
        if param.length > 0 then param += '~~'
        param += val.replace /\s/g, '_'
      param

    # recieve new filters from componenet
    $scope.recieveFilter = (filter) ->
      oldFilter = angular.copy $scope.view.filter
      # check for change - and update view
      if !angular.equals(angular.toJson(filter), angular.toJson(oldFilter))
        # make sure to start on page one
        filter.pagination.page = 0
        # update slides
        updateView filter
        # update params
        updateParams filter

    #  watch query params
    $scope.$watch () ->
      $location.search()
    , (newSearch, oldSearch) ->
      if !angular.equals newSearch, oldSearch
        updateView()
        if $location.search().tags?
          Tags.get {},
            (t) ->
              $scope.view.filter.tag.tags = t
            (e) ->
              console.log e
]