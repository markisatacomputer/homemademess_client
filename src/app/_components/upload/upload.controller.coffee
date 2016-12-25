angular.module 'homemademessClient'
.directive 'upload', ->
  uploadCtrl = [ '$scope', '$location', 'Auth', '$state', 'lodash', '$q', '$mdDialog', 'apiUrl',
  ($scope, $location, Auth, $state, lodash, $q, $mdDialog, apiUrl) ->


  ]
  directive =
    restrict: 'E'
    controller: uploadCtrl
    templateUrl: 'app/components/upload/upload.html'