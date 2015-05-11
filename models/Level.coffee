module.exports = (sequelize, DataTypes) ->

  Level = sequelize.define 'Level',
    name:
      type: DataTypes.STRING

    to_complete:
      type: DataTypes.INTEGER(11)

  , classMethods:
    associate: (models) ->

      Level.belongsTo models.Course,
        onDelete: 'cascade'

      Level.belongsToMany models.Area,
        through: 'LevelAreas'
        onDelete: 'cascade'