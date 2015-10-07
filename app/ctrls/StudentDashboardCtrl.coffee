app.controller 'StudentDashboardCtrl', ['$scope','$http', ($scope,$http) ->
  $http.get '/flights'
  .then (response) ->
    console.log response.data
    $scope.course = response.data.Students
    $scope.getPercent = (levels) ->
      completed = 0
      total = 0
      for level in levels
        total += level.StudentLevel.to_complete
        for mission in level.StudentLevel.StudentMissions
          completed++ if mission.MissionStatusId is 4

      return parseInt completed / total * 100

]