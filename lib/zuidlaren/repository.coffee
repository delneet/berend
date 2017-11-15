ZuidlarenGateway = require('./gateway')

class Repository
  all: ->
    ZuidlarenGateway.get("repositories")
  find: (id) ->
    ZuidlarenGateway.get("repositories/#{id}")

module.exports.Repository = Repository
