express = require('express')
router  = express.Router()
models  = appRequire('models')

router.get '/', (req, res, next) ->
  res.render 'students/welcome'

router.get '/:course_id', (req, res, next) ->
  async = require 'async'

  async.parallel
    course: (callback) ->
      models.Course.find
        where:
          id: req.params.course_id
        include:[
          {
            model: models.Area
            include:[models.Mission,models.Level]
          }
          {
            model: models.Level
          }
        ]

      .then (course) ->
        callback null, course
    missions: (callback) ->
      models.StudentMission.findAll
        include:[{
            model: models.User
            where:
              id: req.user.id
          },
          {
            model: models.Mission
          }
        ]
      .then (missions) ->
        callback null, missions
  , (err, result) ->
    res.render 'students/flight', result

router.post '/mission', (req, res, next) ->
  req.body.UserId = req.user.id
  models.StudentMission.create req.body
  .then (data) ->
    res.sendStatus 200
  .catch (err) ->
    res.sendStatus 200

router.put '/mission', (req, res, next) ->
  req.body.UserId = req.user.id
  models.StudentMission.update req.body,
    where:
      MissionId: req.body.MissionId
      UserId: req.user.id
  .then (data) ->
    res.sendStatus 200
  .catch (err) ->
    res.sendStatus 200
module.exports = router