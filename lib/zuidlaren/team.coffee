ZuidlarenGateway = require('./gateway')

class Team
  all: ->
    ZuidlarenGateway.get("teams")
  find: (id) ->
    ZuidlarenGateway.get("teams/#{id}")

module.exports.Team = Team
