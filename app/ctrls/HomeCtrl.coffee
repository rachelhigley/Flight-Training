app.controller 'HomeCtrl', ['$scope', '$rootScope','$location', ($scope, $rootScope,$location) ->
  console.log $rootScope.user.type
  $location.path '/faculty' if $rootScope.user.type is 'faculty'
  $location.path '/dashboard' if $rootScope.user.type is 'student'
]