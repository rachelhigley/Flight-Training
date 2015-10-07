debug  = require('debug')('migrations')
models = appRequire('models')
module.exports =
  up: (migration, DataTypes, done) ->
    migration.addColumn 'StudentMissions', 'StudentLevelId',
      type: DataTypes.INTEGER,
      references: 'StudentLevels',
      referencesKey: 'id',
      onUpdate: 'CASCADE',
      onDelete: 'RESTRICT'
    .catch (err) ->
      debug err

    models.StudentLevel.findAll()
    .then (studentLevels) ->
      models.StudentMissions.findAll
        attributes: ['id', 'LevelId' , 'UserId','StudentLevelId']
      .then (missions) ->
        for mission in missions
          for studentLevel in studentLevels
            continue unless studentLevel.UserId is mission.UserId
            if studentLevel.LevelId is mission.LevelId
              mission.updateAttributes
                StudentLevelId: studentLevel.id
              break

        migration.removeColumn 'StudentMissions', 'LevelId'
        .catch (err) ->
          debug err

  down: (migration, DataTypes, done) ->
    migration.removeColumn 'StudentMissions', 'StudentLevelId'
    .catch (err) ->
      debug err

     migration.addColumn 'StudentMissions', 'LevelId',
      type: DataTypes.INTEGER,
      references: 'Levels',
      referencesKey: 'id',
      onUpdate: 'CASCADE',
      onDelete: 'RESTRICT'
    .catch (err) ->
      debug err

