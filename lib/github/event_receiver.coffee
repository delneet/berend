EventGroup = require('./../zuidlaren/event_group').EventGroup
GitHubEvents = require('./events/*')

class EventReceiver
  @name = 'github'

  constructor: (request) ->
    @data = request.data
    @event = request.headers["x-github-event"]
    @eventGroup = EventGroup.find(@name)

  valid: ->
    filteredEvents = @eventGroup.events
      .filter (event) ->
        if event.name != @event
          return false # remove anything that isn't this event

        if GitHubEvents[@event]? == false
          return false # event is not implemented

        if event.action == "*"
          return true # wildcard on this event

        if !data.hasOwnProperty('action')
          return true # no action property, let it pass

        if event.action == data.action
          return true # action match

        return false # no match, fail

    filteredEvents.length > 0

  run: (callback) ->
    GitHubEvents[@event](@data, callback)

module.exports.EventReceiver = EventReceiver
