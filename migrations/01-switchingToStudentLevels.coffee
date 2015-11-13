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

    migration.addColumn 'StudentLevels', 'name',
      type: DataTypes.STRING,
    .catch (err) ->
      debug err

    models.StudentLevel.findAll
      include: models.Level
    .then (studentLevels) ->
      models.StudentMission.findAll
        attributes: ['id', 'LevelId' , 'UserId','StudentLevelId']
      .then (missions) ->
        for studentLevel in studentLevels
          studentLevel.updateAttributes
            name: studentLevel.Level.name
          for mission in missions
            continue unless studentLevel.UserId is mission.UserId
            if studentLevel.dataValues.LevelId is mission.dataValues.LevelId
              mission.updateAttributes
                StudentLevelId: studentLevel.id
              break

        migration.removeColumn 'StudentMissions', 'LevelId'
        .catch (err) ->
          debug err
    .catch (err) ->
      debug err
  down: (migration, DataTypes, done) ->
    migration.removeColumn 'StudentMissions', 'StudentLevelId'
    .catch (err) ->
      debug err

    migration.removeColumn 'StudentLevels', 'name'
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

