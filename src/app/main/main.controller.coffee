'use strict'

angular.module 'homemademessClient'
.controller 'MainCtrl', [
  '$scope', '$location', 'view', 'user', 'tgs', 'Slides', 'Tags',
  ($scope, $location, view, user, tgs, Slides, Tags) ->
    # init view
    $scope.view = view
    # add user
    $scope.user = user
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

    #  test object equality
    testEquality = (obj, obj2) ->
      if !angular.equals(angular.toJson(obj), angular.toJson(obj2))
        false
      else
        true

    # recieve new filters from componenet
    $scope.recieveFilter = (filter) ->
      oldFilter = angular.copy $scope.view.filter
      # check for change - and update view
      if !testEquality filter, oldFilter
        # make sure to start on page one IF filter outside of pagination has changed...
        filterCopy = angular.copy filter
        delete filterCopy.pagination
        oldFilterCopy = angular.copy oldFilter
        delete oldFilterCopy.pagination
        if !testEquality filterCopy, oldFilterCopy
          filter.pagination.page = 0
        # update slides
        updateView filter
        # update params
        updateParams filter

    $scope.recieveView = (view) ->
      console.log view
      oldView = angular.copy $scope.view
      # check for change - and update view
      if !testEquality view, oldView
        console.log view
        $scope.view = view

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

    #  listen for user authorization events
    $scope.$on 'userAuth', (e, user) ->
      if !testEquality user, $scope.user
        $scope.user = user

    # react to menu action
    $scope.recieveMenuAction = (action) ->
      if (action.hasOwnProperty 'function') and (angular.isFunction $scope[action.function])
        $scope[action.function] action.arg

    $scope.recieveScopeUpdate = (update) ->
      if action.hasOwnProperty 'name' and action.hasOwnProperty 'value' and $scope[action.name]?
        $scope[action.name] = action.value

    $scope.toggle = (val) ->
      if $scope.hasOwnProperty val
        $scope[val] = !$scope[val]
]