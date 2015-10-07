(function() {
  var app;

  app = angular.module('flight-training', ['ngRoute', 'checklist-model', 'ui.bootstrap', 'ngAnimate', 'textAngular']);

  app.run([
    '$rootScope', '$http', '$location', function($rootScope, $http, $location) {
      return $http.get('/auth').then(function(userInfo) {
        if (!userInfo.data) {
          $location.path('/');
        }
        return $rootScope.user = userInfo.data;
      });
    }
  ]);

  app.config(function($routeProvider) {
    return $routeProvider.when('/', {
      templateUrl: 'views/home',
      controller: 'HomeCtrl'
    }).when('/dashboard', {
      templateUrl: 'views/students/welcome',
      controller: 'StudentDashboardCtrl'
    }).when('/flights/:courseAbbr', {
      templateUrl: 'views/students/flight',
      controller: 'StudentCtrl'
    }).when('/faculty', {
      templateUrl: 'views/faculty/dashboard',
      controller: 'FacultyDashboardCtrl'
    }).when('/faculty/new', {
      templateUrl: 'views/faculty/new',
      controller: 'NewFlightCtrl'
    }).when('/faculty/:courseAbbr', {
      templateUrl: 'views/faculty/flight',
      controller: 'FacultyCtrl'
    }).when('/faculty/:courseAbbr/settings', {
      templateUrl: 'views/faculty/settings',
      controller: 'FlightSettingsCtrl'
    });
  });

  app.controller('FacultyCtrl', [
    '$rootScope', '$scope', '$routeParams', '$http', function($rootScope, $scope, $routeParams, $http) {
      var getCompleted, getTotal;
      $http.get('/faculty/' + $routeParams.courseAbbr).then(function(response) {
        return $scope.course = response.data;
      });
      $scope.addComment = function(mission, newComment) {
        newComment.CommentTypeId = 2;
        newComment.StudentMissionId = mission.id;
        return $http.post("/faculty/mission/comment", newComment).then(function(response) {
          response.data.User = $rootScope.user.user;
          return mission.Comments.push(response.data);
        });
      };
      $scope.changeStatus = function(mission, status) {
        return $http.put("/faculty/mission/status", {
          id: mission.id,
          MissionStatusId: status
        }).then(function(response) {
          if (response.data[0] === 1) {
            return mission.MissionStatusId = status;
          }
        });
      };
      getTotal = function(levels) {
        var i, len, level, total;
        total = 0;
        for (i = 0, len = levels.length; i < len; i++) {
          level = levels[i];
          total += level.to_complete;
        }
        return total;
      };
      getCompleted = function(missions) {
        var completed, i, len, mission;
        completed = 0;
        for (i = 0, len = missions.length; i < len; i++) {
          mission = missions[i];
          if (mission.MissionStatusId === 2) {
            completed++;
          }
        }
        return completed;
      };
      $scope.getPending = function(missions) {
        var i, len, mission, pending;
        pending = 0;
        for (i = 0, len = missions.length; i < len; i++) {
          mission = missions[i];
          if (mission.MissionStatusId === 3) {
            pending++;
          }
        }
        return pending;
      };
      return $scope.getPercent = function(missions, levels) {
        return parseInt(getCompleted(missions) / getTotal(levels) * 100);
      };
    }
  ]);

  app.controller('FacultyDashboardCtrl', [
    '$scope', '$http', function($scope, $http) {
      $http.get('/faculty').then(function(response) {
        console.log(response.data);
        return $scope.courses = response.data.Teachers;
      });
      $scope.getCountStatus = function(missions, status) {
        var count, i, len, mission;
        count = 0;
        for (i = 0, len = missions.length; i < len; i++) {
          mission = missions[i];
          if (mission.MissionStatusId === status) {
            count++;
          }
        }
        return count;
      };
      return $scope.getPending = function(course) {
        var i, len, ref, student, totalPending;
        totalPending = 0;
        ref = course.Students;
        for (i = 0, len = ref.length; i < len; i++) {
          student = ref[i];
          totalPending += $scope.getCountStatus(student.StudentMissions, 3);
        }
        return totalPending;
      };
    }
  ]);

  app.controller('FlightSettingsCtrl', [
    '$scope', '$routeParams', '$http', '$timeout', function($scope, $routeParams, $http, $timeout) {
      $http.get('/faculty/' + $routeParams.courseAbbr + '/settings').then(function(response) {
        return $scope.course = response.data;
      });
      $scope.updateMission = function(mission) {
        return $http.put('/faculty/mission', mission).then(function(response) {
          mission.button = 'Updated!';
          return $timeout(function() {
            return mission.button = false;
          }, 1000);
        });
      };
      $scope.deleteMission = function(area, index) {
        return $http["delete"]("/faculty/mission/" + area[index].id).then(function() {
          return area.splice(index, 1);
        });
      };
      $scope.updateLevel = function(level) {
        return $http.put("/faculty/level", {
          id: level.id,
          to_complete: level.to_complete
        }).then(function(data) {
          return console.log(data);
        });
      };
      $scope.addMission = function() {
        if ($scope.newMission === void 0) {
          return;
        }
        $scope.newMission.courseAbbr = $routeParams.courseAbbr;
        return $http.post('/faculty/mission', $scope.newMission).then(function(response) {
          var area, i, index, len, ref;
          ref = $scope.course.Areas;
          for (index = i = 0, len = ref.length; i < len; index = ++i) {
            area = ref[index];
            if (area.id === parseInt($scope.newMission.AreaId)) {
              index = index;
              break;
            }
          }
          if (!$scope.course.Areas[index].Missions) {
            $scope.course.Areas[index].Missions = [];
          }
          return $scope.course.Areas[index].Missions.push(response.data);
        });
      };
      return $scope.addArea = function() {
        if ($scope.newArea === void 0) {
          return;
        }
        $scope.newArea.courseAbbr = $routeParams.courseAbbr;
        return $http.post('/faculty/area', $scope.newArea).then(function(response) {
          $scope.course.Areas.push(response.data);
          return $scope.newArea = void 0;
        });
      };
    }
  ]);

  app.controller('HomeCtrl', [
    '$scope', '$rootScope', '$location', function($scope, $rootScope, $location) {
      console.log($rootScope.user.type);
      if ($rootScope.user.type === 'faculty') {
        $location.path('/faculty');
      }
      if ($rootScope.user.type === 'student') {
        return $location.path('/dashboard');
      }
    }
  ]);

  app.controller('NewFlightCtrl', [
    '$scope', '$http', '$location', function($scope, $http, $location) {
      return $scope.createFlight = function() {
        return $http.post('/faculty', $scope.newFlight).then(function() {
          return $location.path("/faculty/" + $scope.newFlight.abbr);
        });
      };
    }
  ]);

  app.controller('StudentCtrl', [
    '$rootScope', '$scope', '$routeParams', '$http', function($rootScope, $scope, $routeParams, $http) {
      var getInfo;
      getInfo = function() {
        return $http.get('/flights/' + $routeParams.courseAbbr).then(function(response) {
          return $scope.levels = response.data;
        });
      };
      getInfo();
      $scope.getLevelClass = function(levels, index) {
        var mission;
        if (index === 0) {
          mission = levels[index].StudentMissions[0];
        } else {
          mission = levels[index - 1].StudentMissions[levels[index - 1].StudentMissions.length - 1];
        }
        return $scope.getClass(mission);
      };
      $scope.getClass = function(mission) {
        var cssClass;
        if (!(mission != null ? mission.MissionStatusId : void 0)) {
          return 'select';
        }
        if (mission.selected) {
          return 'selected select';
        }
        cssClass = (function() {
          switch (mission.MissionStatusId) {
            case 1:
              return 'submit';
            case 2:
              return 'resubmit';
            case 3:
              return 'pending';
            case 4:
              return 'complete';
            default:
              return 'select';
          }
        })();
        return cssClass;
      };
      $scope.joinFlight = function() {
        return $http.post("/flights/" + $routeParams.courseAbbr + "/join").then(function(response) {
          getInfo();
          return user.course.push({
            abbr: $routeParams.courseAbbr
          });
        });
      };
      $scope.range = function(array, number) {
        while (array.length < number) {
          array.push({});
        }
        return array;
      };
      $scope.selectMission = function(level, mission, index) {
        return $http.post('/flights/mission', {
          StudentLevelId: level.id,
          MissionId: mission.id,
          MissionStatusId: 1
        }).then(function(response) {
          return level.StudentMissions[index] = {
            MissionStatusId: 1,
            Mission: mission,
            id: response.data.id
          };
        });
      };
      $scope.submitMission = function(mission, link) {
        var data;
        if (!mission.selected) {
          return;
        }
        data = {
          StudentMission: {
            id: mission.id,
            MissionStatusId: 3
          },
          Comment: {
            StudentMissionId: mission.id,
            text: link,
            CommentTypeId: 1
          }
        };
        return $http.put('/flights/mission', data).then(function(response) {
          mission.MissionStatusId = 3;
          if (!mission.Comments) {
            mission.Comments = [];
          }
          mission.Comments.push(data.Comment);
          return mission.selected = false;
        });
      };
      return $scope.deleteMission = function(mission_id, index, level) {
        console.log(mission_id);
        return $http["delete"]("/flights/mission/" + mission_id).then(function() {
          return level.StudentMissions[index] = {};
        });
      };
    }
  ]);

  app.controller('StudentDashboardCtrl', [
    '$scope', '$http', function($scope, $http) {
      return $http.get('/flights').then(function(response) {
        console.log(response.data);
        $scope.course = response.data.Students;
        return $scope.getPercent = function(levels) {
          var completed, i, j, len, len1, level, mission, ref, total;
          completed = 0;
          total = 0;
          for (i = 0, len = levels.length; i < len; i++) {
            level = levels[i];
            total += level.StudentLevel.to_complete;
            ref = level.StudentLevel.StudentMissions;
            for (j = 0, len1 = ref.length; j < len1; j++) {
              mission = ref[j];
              if (mission.MissionStatusId === 4) {
                completed++;
              }
            }
          }
          return parseInt(completed / total * 100);
        };
      });
    }
  ]);

}).call(this);
