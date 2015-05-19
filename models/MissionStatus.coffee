module.exports = (sequelize, DataTypes) ->
  MissionStatus = sequelize.define 'MissionStatus',
    value:
      type: DataTypes.STRING
      allowNull: false
      defaultValue: ''

  , classMethods:
    associate: (models) ->
      MissionStatus.hasMany models.StudentMission,
        onDelete: 'cascade'