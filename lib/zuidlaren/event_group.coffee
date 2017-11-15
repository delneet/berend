ZuidlarenGateway = require('./gateway')

class EventGroup
  all: ->
    ZuidlarenGateway.get("event_groups")
  find: (id) ->
    ZuidlarenGateway.get("event_groups/#{id}")

module.exports.EventGroup = EventGroup
