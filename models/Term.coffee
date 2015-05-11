module.exports = (sequelize, DataTypes) ->

  Term = sequelize.define 'Term',

    name:
      type: DataTypes.STRING

  , classMethods:
    associate: (models) ->

      Term.belongsToMany models.User,
        through: 'Month'
        onDelete: 'cascade'