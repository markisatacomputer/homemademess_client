'use strict'

angular.module 'homemademessClient'
.controller 'MainCtrl', [
  '$scope'
  '$window'
  'view'
  'user'
  'tgs'
  'Slides'
  'Tags'
  'Auth'
  'filterService'
  'paramService'
  'broadcastService'
  'socketService'
  ($scope, $window, view, user, tgs, Slides, Tags, Auth, filterService, paramService, broadcastService, socketService) ->
    # init view
    $scope.view = view
    # add user
    $scope.user = user
    # filters start hidden
    $scope.showFilters = filterService.getDisplay()
    # populate tags for searchbar
    $scope.view.filter.tag.tags = tgs

    # add image map
    mapImages = ->
      $scope.view.map = $scope.view.images.map (i) ->
        return i._id
    mapImages()

    #  set slides to fit filter
    updateView = (filter) ->
      # get params
      params = paramService.getParamsObject filter
      # if filter is passed then we need to update params
      if filter? then paramService.updateParams params
      # now call api to update view
      Slides.get params, (s) ->
        $scope.view = s
        mapImages()
        broadcastService.send 'updateView', s

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
    $scope.$on 'auth.login', (e, user) ->
      $scope.user = user
    $scope.$on 'auth.logout', (e, user) ->
      $scope.user = user

    #  listen for filter toggle
    $scope.$on 'menu.toggleFilters', ->
      $scope.showFilters = filterService.toggleDisplay()

    #  listen for login/logout
    $scope.$on 'menu.toggleAuth', ->
      Auth.toggle()

    socketService.then (s) ->
      #  mark image as in process of deletion
      s.socket.on 'image:delete:begin', (id) ->
        i = $scope.view.map.indexOf id
        if i > -1 then $scope.view.images[i].delete = true

      #  refresh view after successful delete operation
      s.socket.on 'image:delete:complete', (id) ->
        i = $scope.view.map.indexOf id
        if i > -1 then updateView()

      #  temp image is saved as perm
      s.socket.on 'image:upload:complete', (img) ->
        #  remove dropzone preview
        angular.element document.getElementById 'dz-'+img._id
        .addClass 'image-saved'

        #  get view images date boundaries
        createDate  = Number img.createDate
        createDates = []
        createDates.push Number $scope.view.images[0].createDate
        createDates.push Number $scope.view.images[$scope.view.images.length - 1].createDate
        createDates.sort()
        #  if inside then refresh view
        if createDates[0] < createDate and createDates[1] > createDate
          updateView()

]