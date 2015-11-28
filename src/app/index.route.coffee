angular.module 'homemademessClient'
  .config ($stateProvider, $urlRouterProvider) ->
    'ngInject'
    $stateProvider
      .state 'home',
        url: '/'
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
        controllerAs: 'main'
      .state 'home.slide',
        url: 'slide/:slide'
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
      .state 'tagged',
        url: '/tagged/:tag/'
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
      .state 'tagged.slide',
        url: '/tagged/:tag/slide/:slide'
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'

    $urlRouterProvider.otherwise '/'
