'use strict'

User = ($resource, apiUrl, $cookies) ->

  authHeader = (headers) ->
    token = $cookies.get 'token'
    if token
      'Bearer ' + token
    else
      ''

  $resource apiUrl + '/users/:id/:controller',
    id: '@_id'
  ,
    changePassword:
      method: 'PUT'
      params:
        controller: 'password'
      headers:
        'Authorization' : authHeader

    get:
      method: 'GET'
      params:
        id: 'me'
      headers:
        'Authorization' : authHeader

angular.module 'homemademessClient'
.factory 'User', ['$resource', 'apiUrl', '$cookies', User]
