'use strict'

class SelectActionsCtrl
  constructor: ($scope, $mdDialog, selectService, Download) ->
    this.$scope = $scope
    this.$mdDialog = $mdDialog
    this.selectService = selectService
    this.Download = Download

  $onInit: () ->
    ctrl = this

    #  TAG
    this.$scope.$on 'selected.tag', (e) ->
      ctrl.$mdDialog.show
        templateUrl: 'app/components/admin/tag/tagDialog.html'
        controller: 'TagDialogCtrl'
        controllerAs: 'ctrl'

    #  DELETE
    this.$scope.$on 'selected.delete', (e) ->
      ctrl.$mdDialog.show
        templateUrl: 'app/components/admin/delete/deleteDialog.html'
        controller: 'DeleteDialogCtrl'
        controllerAs: 'ctrl'
        locals:
          images: ctrl.selectService.getSelected()
        bindToController: true

    #  DOWNLOAD
    this.$scope.$on 'selected.download', (e) ->
      selected = ctrl.selectService.getSelected()
      dl = (url) ->
        ifrm = document.createElement 'iframe'
        ifrm.setAttribute 'style', 'display:none;'
        ifrm.setAttribute 'src', url
        ifrm.style.width = '0px'
        ifrm.style.height = '0px'
        document.body.appendChild ifrm
      ctrl.Download.many {download: selected}, (data) ->
        links = data.response.split('\r')
        links.forEach (l, i) ->
          if l.length then dl l

    #  Listen for image deletes
    this.$scope.$on 'image.delete.complete', (e, id) ->
      i = ctrl.selectService.selected.indexOf id
      if i >= 0 then ctrl.selectService.selected.splice i, 1

angular.module 'homemademessClient'
.component 'selectActions',
  controller: ['$scope', '$mdDialog', 'selectService', 'Download', SelectActionsCtrl]
