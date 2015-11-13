debug  = require('debug')('migrations')
models = appRequire('models')

module.exports =
  up: (migration, DataTypes, done) ->
    migration.addColumn 'Students', 'archive',
      type: DataTypes.INTEGER,
      defaultValue: 0
    .catch (err) ->
      debug err

  down: (migration, DataTypes, done) ->
    migration.removeColumn 'Students', 'archive'
    .catch (err) ->
      debug err
