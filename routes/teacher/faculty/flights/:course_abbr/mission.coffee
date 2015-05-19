express = require('express')
router  = express.Router()
models  = appRequire('models')


# add mission to the area
router.post '/', (req, res, next) ->
  models.Mission.create req.body
  .then () ->
    res.redirect "/faculty/flights/#{req.course_abbr}/settings"

router.post '/:mission_id', (req, res, next) ->
  models.Mission.update req.body,
    where:
      id: req.params.mission_id
  .then () ->
    res.redirect "/faculty/flights/#{req.course_abbr}/settings"

router.post '/:mission_id/comment', (req, res, next) ->
  req.body.StudentMissionId = req.params.mission_id
  req.body.UserId = req.user.id
  models.Comment.create req.body
  .then (data) ->
    res.redirect "/faculty/flights/#{req.course_abbr}"

# remove mission
router.get '/:mission_id/remove', (req, res, next) ->
  models.Mission.destroy
    where:
      id: req.params.mission_id
  .then () ->
    res.redirect "/faculty/flights/#{req.course_abbr}/settings"

router.get '/:id/:MissionStatusId', (req, res, next) ->
  models.StudentMission.update req.params,
    where:
      id: req.params.id
  .then () ->
    res.redirect "/faculty/flights/#{req.course_abbr}"
module.exports = router