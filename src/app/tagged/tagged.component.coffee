'use strict'

class TaggedCtrl
  constructor: (paramService, broadcastService, Slides, Auth, $window, $scope, $state) ->
    this.paramService = paramService
    this.broadcastService = broadcastService
    this.Slides = Slides
    this.Auth = Auth
    this.$window = $window
    this.$scope = $scope
    this.$state = $state

  $onInit: ->
    ctrl = this

    #  map images
    this.view.map = this.view.images.map (i) ->
      return i._id

    #  listen for user param changes
    this.$scope.$on 'params:update:recieve', (e, newParams) ->
      #  test to make sure params really are different - not just missing values - tagged special case
      params = ctrl.paramService.getParamsObject(ctrl.view.filter)
      params = ctrl.filterTaggedParams params
      angular.forEach newParams, (v, k) ->
        if v != params[k]
          theyredifferent = true
      if theyredifferent? then ctrl.updateView()

    #  listen for user authorization events
    this.$scope.$on 'auth.login', (e, user) ->
      ctrl.user = user
    this.$scope.$on 'auth.logout', (e, user) ->
      ctrl.user = user

    #  listen for login/logout
    this.$scope.$on 'menu.toggleAuth', ->
      ctrl.Auth.toggle()

    #  mark image as in process of deletion
    this.$scope.$on 'image.delete.begin', (e, id) ->
      i = ctrl.view.map.indexOf id
      if i > -1 then ctrl.view.images[i].delete = true
    #  refresh view after successful delete operation
    this.$scope.$on 'image.delete.complete', (e, id) ->
      i = ctrl.view.map.indexOf id
      if i > -1 then ctrl.updateView()
    #  refresh slides after successful upload
    this.$scope.$on 'image.upload.complete', (e, img) ->
      ctrl.updateView()

  mapImages: ->
    #  map images
    this.view.map = this.view.images.map (i) ->
      return i._id

  # recieve new filters from componenet
  recieveFilter: (filter) ->
    oldFilter = angular.copy this.view.filter
    oldPagination = angular.copy oldFilter.pagination
    filterCopy = angular.copy filter
    # check for change - and update view
    if !this.testEquality filterCopy, oldFilter
      delete oldFilter.pagination
      delete filterCopy.pagination
      # make sure to start on page one IF filter outside of pagination has changed...
      if !this.testEquality filterCopy, oldFilter
        filter.pagination.page = 0
      #  scroll to the top of the page if we're on
      if !this.testEquality filter.pagination.page, oldPagination.page
        this.$window.scrollTo 0,0
      # update view with new filter
      filter = this.filterTaggedFilter filter
      console.log 'recieveFilter', filter
      this.updateView filter

  #  set slides to fit filter
  updateView: (filter) ->
    ctrl = this

    # get params
    params = this.paramService.getParamsObject filter
    taggedParams = this.filterTaggedParams params
    # if filter is passed then we need to update params
    if filter? then this.paramService.updateParams taggedParams
    # now call api to update view
    this.Slides.get params, (s) ->
      ctrl.view = s
      ctrl.mapImages()
      #  broadcast
      ctrl.broadcastService.send 'updateView', ctrl.view

  #  test object equality
  testEquality: (obj, obj2) ->
    if !angular.equals angular.toJson(obj), angular.toJson(obj2)
      false
    else
      true

  #  filter params for tagged view
  filterTaggedParams: (params) ->
    taggedParams = angular.copy params
    delete taggedParams.tagtext
    if taggedParams.order is "createDate" then delete taggedParams.order
    taggedParams

  #  filter params for tagged view
  filterTaggedFilter: (filter) ->
    if filter.tagtext is null then filter.tagtext = this.tag[0].text
    if filter.order is null then filter.order = "createDate"
    filter

angular.module 'homemademessClient'
.component 'taggedDisplay',
  bindings:
    view: '<'
    user: '<'
    tag: '<'
    previous: '<'
  templateUrl: 'app/tagged/tagged.html'
  controller: ['paramService', 'broadcastService', 'Slides', 'Auth', '$window', '$scope', '$state', TaggedCtrl]
