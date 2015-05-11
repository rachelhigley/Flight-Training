module.exports = (sequelize, DataTypes) ->

  Mission = sequelize.define 'Mission',
    name:
      type: DataTypes.STRING

    description:
      type: DataTypes.BLOB('long')

  , classMethods:
    associate: (models) ->

      Mission.belongsTo models.Area,
        onDelete: 'cascade'