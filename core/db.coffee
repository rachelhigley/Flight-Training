env       = process.env.NODE_ENV or 'development'
Sequelize = require('sequelize')
sequelize = require('sequelize-heroku').connect()
unless sequelize
  config = appRequire('config/config.json')[env]
  config.logging = ->
  sequelize = new Sequelize(config.database, config.username, config.password, config)

module.exports = sequelize
