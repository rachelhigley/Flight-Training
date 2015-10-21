Umzug     = require('umzug')
Sequelize = require('sequelize')
models    = appRequire('models')

module.exports = (callback) ->
  models.sequelize.sync().then ->
    umzug = new Umzug
      storage: 'sequelize'
      storageOptions:
        sequelize: models.sequelize

      migrations:
        path: __dirname+'/../migrations'
        pattern: /^\d+[\w-]+\.coffee$/
        params: [models.sequelize.getQueryInterface(), Sequelize]

    umzug.up().then (migrations) ->
      models.UserType.bulkCreate user_type_data
      .catch (err) ->

      models.MissionStatus.bulkCreate mission_status_data
      .catch (err) ->

      models.CommentType.bulkCreate comment_type_data
      .catch (err) ->

      models.LockType.bulkCreate lock_type_data
      .catch (err) ->

      callback()

user_type_data = [ {
  id: 1
  value: 'student'
},
{
  id: 2
  value: 'teacher'
}
]

mission_status_data = [ {
  id: 1
  value: 'incomplete'
},
{
  id: 2
  value: 'rejected'
},
{
  id: 3
  value: 'completed'
},
{
  id: 4
  value: 'accepted'
}
]

comment_type_data = [ {
  id: 1
  value: 'submit link'
},
{
  id: 2
  value: 'comment'
}
]

lock_type_data = [ {
  id: 1
  value: 'All levels unlocked'
},
{
  id: 2
  value: 'Lock level until previous missions have been submited'
},
{
  id: 3
  value: 'Lock level until previous missions have been accepted'
}
]