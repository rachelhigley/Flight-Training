app.config ($routeProvider) ->
  $routeProvider
  .when '/',
    templateUrl: 'views/home'
    controller: 'HomeCtrl'
  .when '/dashboard',
    templateUrl: 'views/students/welcome'
    controller: 'StudentDashboardCtrl'
  .when '/flights/:courseAbbr',
    templateUrl: 'views/students/flight'
    controller: 'StudentCtrl'
  .when '/faculty',
    templateUrl: 'views/faculty/dashboard'
    controller: 'FacultyDashboardCtrl'
  .when '/faculty/new',
    templateUrl: 'views/faculty/new'
    controller: 'NewFlightCtrl'
  .when '/faculty/:courseAbbr',
    templateUrl: 'views/faculty/flight'
    controller: 'FacultyCtrl'
  .when '/faculty/:courseAbbr/settings',
    templateUrl: 'views/faculty/settings'
    controller: 'FlightSettingsCtrl'