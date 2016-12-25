angular.module 'homemademessClient'
  .config ($stateProvider, $urlRouterProvider) ->
    'ngInject'


    $stateProvider
      .state 'home',
        url: '/'
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
        resolve:
          slides: ($http, apiUrl) ->
            $http.get apiUrl + '/images'
          map: (slides, lodash) ->
            lodash.indexBy slides.data.images, '_id'
      .state 'home.slide',
        url: 'slide/:slide'
        templateUrl: 'app/components/slideshow/slideshow.html'
        controller: 'slideshowCtrl'
        resolve:
          slide: ($transition$, map) ->
            $transition$.params().slide
        onEnter: ($transition$, $document, $rootScope, debounce) ->
          if $transition$.to().name.indexOf('slide') >= 0 and !angular.element(document.querySelector('body')).hasClass 'slideshow'
            # set delay
            bounce = 400
            # body class
            angular.element document.querySelector 'body'
            .addClass 'slideshow'
            # click outside of slide to close
            angular.element document.querySelector '.slideshow'
            .off 'click'
            .on 'click', debounce (e) ->
              test = angular.element (e.target)
              if test[0].nodeName != "IMG"
                $rootScope.$broadcast 'slideout'
            , bounce, false
            # keyboard events
            $document
            .off 'keyup'
            .on 'keyup', debounce (e) ->
              switch e.which
                when 39 then $rootScope.$broadcast 'slideright'
                when 37 then $rootScope.$broadcast 'slideleft'
                when 38 then $rootScope.$broadcast 'slideup'
                when 40 then $rootScope.$broadcast 'slidedown'
                when 27 then $rootScope.$broadcast 'slideout'
            , bounce, true

        onExit: ($transition$, $document, $rootScope) ->
          if $transition$.to().name.indexOf('slide') is -1 and angular.element(document.querySelector('body')).hasClass 'slideshow'
            angular.element document.querySelector 'body'
            .removeClass 'slideshow'
            # remove click listener
            angular.element document.querySelector '.slideshow'
            .off 'click'
            # unbind keyboard
            $document.off 'keyup'
      .state 'home.tagged',
        url: 'tagged/:tag/'
        templateUrl: 'app/main/tagged/tagged.html'
        controller: 'TaggedCtrl'
      .state 'home.tagged.slide',
        url: 'slide/:slide'
        templateUrl: 'app/components/slideshow/slideshow.html'
        controller: 'slideshowCtrl'

    $urlRouterProvider.otherwise '/'
