module.exports = (sequelize, DataTypes) ->

  Student = sequelize.define 'Student',
    archive:
      type: DataTypes.INTEGER(1)

  , classMethods:
    associate: (models) ->
      Student.belongsTo models.Course
      Student.belongsTo models.User
