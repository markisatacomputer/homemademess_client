angular.module 'homemademessClient'
  .config ($stateProvider, $urlRouterProvider) ->
    'ngInject'
    $stateProvider
      .state 'home',
        url: '/'
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
        controllerAs: 'main'
      .state 'tagged',
        url: '/tagged/:tag'
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
      .state 'slide',
        url: '/slide/:slide'
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'

    $urlRouterProvider.otherwise '/'
