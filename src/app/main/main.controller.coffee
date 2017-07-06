'use strict'

angular.module 'homemademessClient'
.controller 'MainCtrl', [
  '$scope'
  '$window'
  'view'
  'user'
  'tag'
  'Slides'
  'Tags'
  'Auth'
  'paramService'
  'broadcastService'
  'socketService'
  ($scope, $window, view, user, tag, Slides, Tags, Auth, paramService, broadcastService, socketService) ->
    # init view
    $scope.view = view
    # add user
    $scope.user = user

    # populate tags for searchbar
    $scope.view.filter.tag.tags = tag

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
        s.images.forEach (slide, i) ->
          n = $scope.view.map.indexOf slide._id
          if n == -1
            $scope.view.images.splice i, 1, slide
            $scope.view.map.splice i, 1, slide._id
          else if n != i
            $scope.view.images.splice i, 1, slide
            $scope.view.map.splice i, 1, slide._id
            $scope.view.images.splice n, 1
            $scope.view.map.splice n, 1
        if s.images.length < $scope.view.images.length
          $scope.view.images = $scope.view.images.slice 0, s.images.length
          $scope.view.map = $scope.view.map.slice 0, s.images.length
        $scope.view.filter = s.filter
        broadcastService.send 'updateView', s

    #  test object equality
    testEquality = (obj, obj2) ->
      if !angular.equals angular.toJson(obj), angular.toJson(obj2)
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
      else console.log filterCopy, oldFilter

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
      s.socket.on 'image:upload:begin', (img) ->
        #  broadcast
        broadcastService.send 'image.upload.begin', img

      #  temp image is saved as perm
      s.socket.on 'image:upload:complete', (img) ->
        #  broadcast
        broadcastService.send 'image.upload.complete', img
        #  refresh slides
        updateView()

]