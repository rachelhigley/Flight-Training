express = require('express')
router  = express.Router()
models  = appRequire('models')

# create new terms for the course
router.post '/', (req, res, next) ->
  models.Term.create
    name: req.body.name
    CourseId: req.course_id
  .then () ->
    res.redirect '/faculty/flights/'+req.course_id

router.get '/:term_id', (req, res, next) ->
  async  = require('async')
  async.parallel
    term: (callback) ->
      models.Term.find req.params.term_id,
        include: [models.Course,models.User]
      .then (term) ->
        callback null, term
    users: (callback) ->
      models.User.findAll
        where:
          UserTypeId: 1
      .then (users) ->
        callback null, users
    missions: (callback) ->
      models.StudentMission.findAll
        where:
          MissionStatusId: 2
        include: [
          {
            model: models.User
            where:
              UserTypeId: 1
            include:
              model: models.Term
              where:
                id: req.params.term_id
          },
          {
            model: models.Mission
            include:
              model: models.Area
              where:
                CourseId: req.course_id
          }
        ]
      .then (missions) ->
        callback null, missions
  , (err, result) ->
    res.render 'faculty/term', result

# update the mission
router.get '/:term_id/mission/:mission_id/:status_id', (req, res, next) ->
  console.log req.params
  models.StudentMission.update
    MissionStatusId: req.params.status_id
  ,
    where:
      MissionId: req.params.mission_id
  .then (data) ->
    console.log data
    res.redirect "/faculty/flights/#{req.course_id}/term/#{req.params.term_id}"

router.post '/:term_id/student', (req, res, next) ->
  models.Term.find req.params.term_id
  .then (term) ->
    term.addUser req.body.UserId
    res.redirect "/faculty/flights/#{req.course_id}/term/#{req.params.term_id}"

module.exports = router