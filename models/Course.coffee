module.exports = (sequelize, DataTypes) ->

  Course = sequelize.define 'Course',
    name:
      type: DataTypes.STRING

    abbr:
      type: DataTypes.STRING

  , classMethods:
    associate: (models) ->
      Course.belongsToMany models.User,
        through: 'Teachers'
        onDelete: 'cascade'

      Course.hasMany models.Term,
        onDelete: 'cascade'

      Course.hasMany models.Level,
        onDelete: 'cascade'

       Course.hasMany models.Area,
        onDelete: 'cascade'