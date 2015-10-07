app.controller 'NewFlightCtrl', ['$scope','$http','$location', ($scope,$http,$location) ->

  $scope.createFlight = () ->
    $http.post '/faculty', $scope.newFlight
    .then () ->
      $location.path "/faculty/#{$scope.newFlight.abbr}"
]