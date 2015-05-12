module.exports = (sequelize, DataTypes) ->

  Term = sequelize.define 'Term',

    name:
      type: DataTypes.STRING

  , classMethods:
    associate: (models) ->

      Term.belongsTo models.Course,
        onDelete: 'cascade'
      Term.belongsToMany models.User,
        through: 'Month'
        onDelete: 'cascade'