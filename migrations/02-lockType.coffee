debug  = require('debug')('migrations')
module.exports =
  up: (migration, DataTypes, done) ->
    migration.addColumn 'Courses', 'LockTypeId',
      type: DataTypes.INTEGER,
      references: 'LockTypes',
      referencesKey: 'id',
      onUpdate: 'CASCADE',
      onDelete: 'RESTRICT'
      default: 1
    .catch (err) ->
      debug err

  down: (migration, DataTypes, done) ->
    migration.removeColumn 'Courses', 'LockTypeId'
    .catch (err) ->
      debug err
