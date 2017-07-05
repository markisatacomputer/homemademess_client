'use strict'

class FilterCtrl
  constructor: (filterService) ->
    this.filterService = filterService
    this.selected = false

  $onInit: () ->
    ctrl = this

    this.selected = this.filter.selected

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
  controller: ['filterService', FilterCtrl]
