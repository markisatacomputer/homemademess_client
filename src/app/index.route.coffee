angular.module 'homemademessClient'
  .config ($stateProvider, $urlRouterProvider) ->
    'ngInject'

    slideshowExit = ($transition$, $document, $rootScope) ->
      if $transition$.to().name.indexOf('slide') is -1 and angular.element(document.querySelector('body')).hasClass 'slideshow'
        angular.element document.querySelector 'body'
        .removeClass 'slideshow'
        # remove click listener
        angular.element document.querySelector '.slideshow'
        .off 'click'
        # unbind keyboard
        $document.off 'keyup'

    $stateProvider
      .state 'home',
        url: '/'
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
        resolve:
          slides: ($http, apiUrl) ->
            $http.get apiUrl + '/images'
            .then (s)->
              s.data.images
          map: (slides, lodash) ->
            lodash.indexBy slides, '_id'
          user: (Auth) ->
            Auth.getCurrentUser()
      .state 'home.slideshow',
        url: 'slide/'
        component: 'slideshow'
        onExit: slideshowExit
      .state 'home.slideshow.slide',
        url: ':slide/'
        component: 'slide'
      .state 'home.search',
        url: 'search/:tags/'
        templateUrl: 'app/components/searchbar/searchbar.html'
        controller: 'SearchCtrl'
      .state 'home.tagged',
        url: 'tagged/:tag/'
        templateUrl: 'app/main/tagged/tagged.html'
        controller: 'TaggedCtrl'
      .state 'home.tagged.slideshow',
        url: 'slide/:slide/'
        templateUrl: 'app/components/slideshow/slideshow.html'
        controller: 'slideshowCtrl'

    $urlRouterProvider.otherwise '/'

    ###.state 'home.slideshow',
        url: 'slide/:slide/'
        component: 'slideshow'
        onEnter: slideshowEnter
        onExit: slideshowExit
        resolve:
          slideId: ($transition$) ->
            $transition$.params().slide
        views:
          slide: 'slide'###
