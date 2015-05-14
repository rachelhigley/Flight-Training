module.exports = (sequelize, DataTypes) ->

  StudentMission = sequelize.define 'StudentMission', {}
  , classMethods:
    associate: (models) ->
      StudentMission.belongsTo models.User
      StudentMission.belongsTo models.Mission
      StudentMission.belongsTo models.MissionStatus
      StudentMission.belongsTo models.Level
      StudentMission.hasMany models.Comment