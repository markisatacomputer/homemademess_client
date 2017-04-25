'use strict'

class SelectedCtrl
  constructor: (broadcastService, selectService, $rootScope) ->
    this.broadcastService = broadcastService
    this.selectService = selectService
    this.$scope = $rootScope

  clssSelected: (add)->
    if !add? then add = true
    selected = this.selectService.getSelected()

    if add
      angular.forEach selected, (id, i) ->
        angular.element(document.getElementById(id)).addClass('selected')
      angular.element(document).find('body').addClass('has-selected')
    else
      angular.forEach selected, (id, i) ->
        angular.element(document.getElementById(id)).removeClass('selected')
      angular.element(document).find('body').removeClass('has-selected')

  $onInit: () ->
    ctrl = this
    #  select events
    this.$scope.$on 'slide.select', (e, slide) ->
      ctrl.selectService.toggle slide._id
    this.$scope.$on 'select.on', (e, id) ->
      angular.element(document.getElementById(id)).addClass('selected')
    this.$scope.$on 'select.off', (e, id) ->
      angular.element(document.getElementById(id)).removeClass('selected')
    this.$scope.$on 'select.has-selected', (e) ->
      angular.element(document).find('body').addClass('has-selected')
    this.$scope.$on 'select.empty', (e) ->
      angular.element(document).find('body').removeClass('has-selected')

    #  on slides change, class
    this.$scope.$on 'slidesLayout', (e) ->
      ctrl.clssSelected()

  $onDestroy: () ->
    this.clssSelected false

angular.module 'homemademessClient'
.component 'selectedControl',
  controller: SelectedCtrl