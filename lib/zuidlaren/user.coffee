ZuidlarenGateway = require('./gateway')

class User
  all: ->
    ZuidlarenGateway.get("users")
  find: (id) ->
    ZuidlarenGateway.get("users/#{id}")

module.exports.User = User
