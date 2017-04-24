'use strict'

angular.module 'homemademessClient'
.controller 'MainCtrl', [
  '$scope', '$window', 'view', 'user', 'tgs', 'Slides', 'Tags', 'Auth', 'filterService', 'paramService',
  ($scope, $window, view, user, tgs, Slides, Tags, Auth, filterService, paramService) ->
    # init view
    $scope.view = view
    # add user
    $scope.user = user
    # filters start hidden
    $scope.showFilters = filterService.getDisplay()
    # populate tags for searchbar
    $scope.view.filter.tag.tags = tgs


    #  set slides to fit filter
    updateView = (filter) ->
      # get params
      params = paramService.getParamsObject filter
      # if filter is passed then we need to update params
      if filter? then paramService.updateParams params
      # now call api to update view
      Slides.get params,
        (s) ->
          $scope.view = s
        (e) ->
          console.log e

    #  test object equality
    testEquality = (obj, obj2) ->
      if !angular.equals(angular.toJson(obj), angular.toJson(obj2))
        false
      else
        true

    # recieve new filters from componenet
    $scope.recieveFilter = (filter) ->
      oldFilter = angular.copy $scope.view.filter
      oldPagination = angular.copy oldFilter.pagination
      filterCopy = angular.copy filter
      # check for change - and update view
      if !testEquality filterCopy, oldFilter
        delete oldFilter.pagination
        delete filterCopy.pagination
        # make sure to start on page one IF filter outside of pagination has changed...
        if !testEquality filterCopy, oldFilter
          filter.pagination.page = 0
        #  scroll to the top of the page if we're on
        if !testEquality filter.pagination.page, oldPagination.page
          $window.scrollTo 0,0
        # update view with new filter
        updateView filter

    # TODO - fix flashing on update
    $scope.recieveView = (view) ->
      oldView = angular.copy $scope.view
      # check for change - and update view
      if !testEquality view, oldView
        $scope.view = view

    #  listen for user param changes
    $scope.$on 'params:update:recieve', (newParams) ->
      updateView()
      if newParams.tags?
        Tags.get {},
          (t) ->
            $scope.view.filter.tag.tags = t
          (e) ->
            console.log e

    #  listen for user authorization events
    $scope.$on 'userAuth', (e, user) ->
      if !testEquality user, $scope.user
        $scope.user = user

    #  listen for filter toggle
    $scope.$on 'menu.toggleFilters', ->
      $scope.showFilters = filterService.toggleDisplay()

    #  listen for login/logout
    $scope.$on 'menu.toggleAuth', ->
      Auth.toggle()


]