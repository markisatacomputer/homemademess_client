'use strict'

class SlidesCtrl
  constructor: ($scope, $state, broadcastService, $mdMedia, selectService) ->
    this.$scope = $scope
    this.$state = $state
    this.broadcastService = broadcastService
    this.$mdMedia = $mdMedia
    this.selectService = selectService
    this.cols =
      sm: 24
      md: 36
      lg: 48
      gt: 60
    this.derivative = 0

  getLink: (id) ->
    this.$state.href this.$state.$current.name + '.slideshow.slide', {slide: id}

  ratio: (img) ->
    #  Get aspect ratio as decimal
    Math.round((img.height/img.width)*100)/100

  aspect: (img,n) ->
    a = this.ratio img
    #  Set columns/rows
    columns = switch
      #  If pano span page width
      when a < 0.4
        switch
          when this.$mdMedia 'sm'
            this.derivative = 0
            this.cols.sm
          when this.$mdMedia 'md'
            this.derivative = 0
            this.cols.md
          when this.$mdMedia 'lg'
            this.derivative = 1
            this.cols.lg
          when this.$mdMedia 'gt-lg'
            this.derivative = 1
            this.cols.gt
      #  Default one column
      else
        this.derivative = 0
        12
    rows = Math.round columns*a
    aspect = [columns, rows]
    aspect[n]

  toggleSelect: (id, value) ->
    i = this.map.indexOf id
    if i > -1
      this.view.images[i].selected = value

  toggleSelectAll: (value) ->
    ctrl = this
    angular.forEach this.view.images, (img, i) ->
      ctrl.view.images[i].selected = value

  $onInit: () ->
    ctrl = this

    #  Map image ids
    this.map = this.view.images.map (i) ->
      return i._id

    #  draw selected images
    this.$scope.$on 'select.on', (e, id) ->
      ctrl.toggleSelect id, true
    this.$scope.$on 'select.off', (e, id) ->
      ctrl.toggleSelect id, false
    this.$scope.$on 'select.all', () ->
      ctrl.toggleSelectAll true
    this.$scope.$on 'select.none', () ->
      ctrl.toggleSelectAll false
    this.$scope.$on 'auth.logout', () ->
      ctrl.toggleSelectAll false
    this.$scope.$on 'auth.login', () ->
      ctrl.selectService.getSelected().then (s) ->
        angular.forEach ctrl.view.images, (img, i) ->
          if s.indexOf(img._id) > -1
            ctrl.view.images[i].selected = true

    ###  Wait for socket
    this.socketService.then (s) ->
      ctrl.socketService = s
      #  Register Listeners
      ctrl.socketService.socket.on 'image:update', (img) ->
        console.log 'update', img
        i = ctrl.map.indexOf(img._id)
        if i > -1
          ctrl.view.images[i] = img
      ctrl.socketService.socket.on 'image:save', (img) ->
        console.log 'save', img
      ctrl.socketService.socket.on 'image:remove', (img) ->
        console.log 'remove', img
    ###

  $onChanges: (changes) ->
    #  Map image ids
    this.map = this.view.images.map (i) ->
      return i._id

angular.module 'homemademessClient'
.component 'slides',
  bindings:
    view: '<'
    user: '<'
  templateUrl: 'app/components/slides/slides.html'
  controller: SlidesCtrl
