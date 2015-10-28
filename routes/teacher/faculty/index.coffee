express = require('express')
router  = express.Router()
models  = appRequire('models')

# get the course for every route
router.param 'course_abbr',(req, res, next, abbr) ->
  models.Course.find
    where:
      abbr: abbr
  .then (course) ->
    req.course = course
    req.course_id = course.id
    next()

router.get '/', (req, res, next) ->
  models.User.find
    where:
      id: req.user.id
    include:
      model: models.Course
      as: 'Teachers'
      include:
        model: models.User
        as: 'Students'
        include:[
          model: models.StudentMission
          include: models.Mission
        ]
  .then (user) ->
    res.send user


# create a course
router.post '/', (req, res,next) ->
  models.Course.create req.body
  .then (course) ->
    course.addTeacher req.user.id

    models.Level.bulkCreate [{
        CourseId: course.id
        name: 'Takeoff'
        to_complete: 5
      },
      {
        CourseId: course.id
        name: 'Climb'
        to_complete: 5
      },
      {
        CourseId: course.id
        name: 'Cruise'
        to_complete: 5
      },
      {
        CourseId: course.id
        name: 'Descent'
        to_complete: 5
      },
      {
        CourseId: course.id
        name: 'Landing'
        to_complete: 1
      }
      ]

    res.sendStatus 200

# get a course for the teacher
router.get '/:course_abbr', (req, res, next) ->
  models.Course.find req.course_id,
    include:
      model: models.User
      as: 'Students'
      include:[{
        model: models.StudentLevel
        include: {
          model: models.Level
          where:
            CourseId: req.course_id
        }
      },
      {
        model: models.StudentMission
        include:[
          {
            model: models.Mission
          }
          {
            model: models.Comment
            include: models.User
          }
        ]
      }]
    order: [[{ model: models.User, as: 'Students' }, models.StudentMission, 'MissionStatusId', 'DESC'], [{ model: models.User, as: 'Students' }, models.StudentMission, models.Comment, 'updatedAt', 'ASC'], [{ model: models.User, as: 'Students' },'createdAt', 'ASC']]
  .then (course) ->
    if course
      for student in course.Students
        for mission in student.StudentMissions
          for comment in mission.Comments
            comment.text = comment.text?.toString('utf8')
      res.send course
    else
      res.send req.course
  .catch (err) ->
    console.log err

# view the course missions
router.get '/:abbr/settings', (req, res, next) ->
  models.Course.find
    where:
      abbr: req.params.abbr
    include: [models.Level, {
      model: models.Area
      include:
        model: models.Mission
        order: ['id','ASC']
      }]
    order: [[models.Level, 'id','ASC'], [models.Area, models.Mission, 'id','ASC']]
  .then (course) ->
    models.LockType.findAll().then (types) ->

      for area in course.Areas
        for mission in area.Missions
          mission.description = mission.description?.toString('utf8')
      course.dataValues.LockTypes = types
      res.send course

# update the lock level
router.put '/course', (req, res, next) ->
  models.Course.update req.body,
    where:
      id: req.body.id
  .then (data) ->
    res.send data


module.exports = router