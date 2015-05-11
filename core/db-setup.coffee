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