app.controller 'FacultyDashboardCtrl', ['$scope','$http', ($scope, $http) ->
  $http.get '/faculty'
  .then (response) ->
    console.log response.data
    $scope.courses = response.data.Teachers

  $scope.getCountStatus = (missions, status) ->
    count = 0

    for mission in missions
      count++ if mission.MissionStatusId is status

    count

  $scope.getPending = (course) ->
    totalPending = 0

    for student in course.Students
      totalPending += $scope.getCountStatus student.StudentMissions, 3

    totalPending

]