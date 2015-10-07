module.exports = (sequelize, DataTypes) ->

  StudentLevel = sequelize.define 'StudentLevel',

    to_complete:
      type: DataTypes.INTEGER(11)

    name:
      type: DataTypes.STRING


  , classMethods:
    associate: (models) ->

      StudentLevel.belongsTo models.Level,
        onDelete: 'cascade'

      StudentLevel.belongsTo models.User,
        onDelete:'cascade'

      StudentLevel.hasMany models.StudentMission,
        onDelete: 'cascade'