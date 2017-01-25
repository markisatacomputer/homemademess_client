'use strict'

class PagerCtrl
  constructor: () ->
    this.previous = false
    this.next = false
    this.total = 0
    this.page = 0

  $onChanges: (changes) ->
    if this.filter?
      this.getPages()

  changePage: (direction) ->
    filter = angular.copy this.filter
    filter.pagination.page = switch direction
      when 'next' then this.filter.pagination.page + 1
      when 'previous' then this.filter.pagination.page - 1
    this.onUpdate {filter: filter}

  getPages: () ->
    this.total = Math.round(this.filter.pagination.count/this.filter.pagination.per)-1
    this.page = this.filter.pagination.page
    if this.total > this.page
      this.next = true
    else
      this.next = false
    if this.page > 0
      this.previous = true
    else
      this.previous = false

angular.module 'homemademessClient'
.component 'pager',
  bindings:
    filter: '<'
    onUpdate: '&'
  templateUrl: 'app/components/pager/pager.html'
  controller: PagerCtrl
