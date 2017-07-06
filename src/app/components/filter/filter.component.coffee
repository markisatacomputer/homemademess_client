'use strict'

class FilterCtrl
  constructor: (filterService, $scope) ->
    this.filterService = filterService
    this.$scope = $scope
    this.showFilters = null
    this.selected = false

  $onInit: () ->
    ctrl = this

    this.selected = this.filter.selected

    # filters start hidden
    this.showFilters = this.filterService.getDisplay()
    #  listen for filter toggle
    this.$scope.$on 'menu.toggleFilters', ->
      ctrl.showFilters = ctrl.filterService.toggleDisplay()

  $onChanges: () ->
    this.selected = this.filter.selected

  updateSelect: () ->
    filter = angular.copy this.filter
    filter.selected = this.selected
    this.onUpdate {filter: filter}

angular.module 'homemademessClient'
.component 'filter',
  bindings:
    filter: '<'
    user: '<'
    onUpdate: '&'
  templateUrl: 'app/components/filter/filter.html'
  controller: ['filterService', '$scope', FilterCtrl]
