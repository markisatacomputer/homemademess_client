'use strict'

authService = ($http, User, $cookies, $mdDialog, apiUrl, broadcastService) ->
  currentUser = if $cookies.get 'token' then User.get(
    {}
    (u) ->
      if u.role = 'admin'
        $http.defaults.headers.common.Authorization = 'Bearer ' + $cookies.get 'token'
    (e) ->
      $cookies.remove 'token'
      delete $http.defaults.headers.common.Authorization
  ) else {}

  ###
  Authenticate user and save token

  @param  {Object}   user     - login info
  @param  {Function} callback - optional
  @return {Promise}
  ###
  login: (user, callback) ->
    $http.post apiUrl + '/auth/local',
      email: user.email
      password: user.password

    .then (res) ->
      #  save token in cookie
      now = new Date()
      $cookies.put 'token', res.data.token, { expires: new Date(now.getTime() + (4*60*60*1000) ) }
      #  set default Authorization header
      $http.defaults.headers.common.Authorization = 'Bearer ' + res.data.token
      #  set current user
      currentUser = User.get()
      callback? res, currentUser
      #  broadcast user
      broadcastService.send 'auth.login', currentUser
      currentUser

    , (err) =>
      @logout()
      callback? err
      err

  ###
  Delete access token and user info

  @param  {Function}
  ###
  logout: ->
    $cookies.remove 'token'
    delete $http.defaults.headers.common.Authorization
    currentUser = {}
    broadcastService.send 'auth.logout', currentUser
    return


  ###
  Create a new user

  @param  {Object}   user     - user info
  @param  {Function} callback - optional
  @return {Promise}
  ###
  createUser: (user, callback) ->
    User.save user,
      (data) ->
        $cookies.put 'token', data.token
        currentUser = User.get()
        callback? user

      , (err) =>
        @logout()
        callback? err

    .$promise


  ###
  Change password

  @param  {String}   oldPassword
  @param  {String}   newPassword
  @param  {Function} callback    - optional
  @return {Promise}
  ###
  changePassword: (oldPassword, newPassword, callback) ->
    User.changePassword
      id: currentUser._id
    ,
      oldPassword: oldPassword
      newPassword: newPassword

    , (user) ->
      callback? user

    , (err) ->
      callback? err

    .$promise


  ###
  Gets all available info on authenticated user

  @return {Object} user
  ###
  getCurrentUser: ->
    currentUser


  ###
  Check if a user is logged in synchronously

  @return {Boolean}
  ###
  isLoggedIn: ->
    currentUser.hasOwnProperty 'role'


  ###
  Waits for currentUser to resolve before checking if user is logged in
  ###
  isLoggedInAsync: (callback) ->
    if currentUser.hasOwnProperty '$promise'
      currentUser.$promise.then ->
        callback? true
        return
      .catch ->
        callback? false
        return

    else
      callback? currentUser.hasOwnProperty 'role'

  ###
  Check if a user is an admin

  @return {Boolean}
  ###
  isAdmin: ->
    currentUser.role is 'admin'


  ###
  Get auth token
  ###
  getToken: ->
    $cookies.get 'token'

  toggle: ->
    ctrl = this
    ctrl.isLoggedInAsync (loggedIn) ->
      if loggedIn
        ctrl.logout()
      else
        $mdDialog.show
          clickOutsideToClose: true
          templateUrl: '/app/account/login/login.html'
          controller: 'LoginCtrl'


angular.module 'homemademessClient'
.factory 'Auth', ['$http', 'User', '$cookies', '$mdDialog', 'apiUrl', 'broadcastService', authService]
