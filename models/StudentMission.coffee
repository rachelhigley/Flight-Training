module.exports = (sequelize, DataTypes) ->

  StudentMission = sequelize.define 'StudentMission', {}
  , classMethods:
    associate: (models) ->
      StudentMission.belongsTo models.User,
        onDelete: 'cascade'
      StudentMission.belongsTo models.Mission,
        onDelete: 'cascade'
      StudentMission.belongsTo models.MissionStatus,
        onDelete: 'cascade'
      StudentMission.belongsTo models.StudentLevel,
        onDelete: 'cascade'
      StudentMission.hasMany models.Comment,
        onDelete: 'cascade'