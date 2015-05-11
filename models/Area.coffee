module.exports = (sequelize, DataTypes) ->

  Area = sequelize.define 'Area',
    name:
      type: DataTypes.STRING

  , classMethods:
    associate: (models) ->
      Area.belongsToMany models.Level,
        through: 'LevelAreas'
        onDelete: 'cascade'

      Area.belongsTo models.Course,
        onDelete: 'cascade'

      Area.hasMany models.Mission,
        onDelete: 'cascade'