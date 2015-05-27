express = require('express')
router  = express.Router()
models  = appRequire('models')

router.param 'course_abbr',(req, res, next, abbr) ->

  models.Course.find
    where:
      abbr: abbr
  .then (course) ->
    req.course_id = course.id
    next()

# route for craeting a course
router.get '/new', (req, res, next) ->
  res.render 'faculty/new'

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

    res.redirect '/faculty/dashboard'

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
        include:[ models.Mission,
          {
            model: models.Comment
            include: models.User
          }
          , {
            model: models.Level
            where:
              CourseId: req.course_id
          }
        ]
      }]
  .then (course) ->
    console.log course
    res.render 'faculty/flight', course: course

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
    res.render 'faculty/settings.jade', course: course

module.exports = router