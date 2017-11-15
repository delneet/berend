GitHubEventReceiver = require('./../lib/github/event_receiver').EventReceiver
SlackMessage = require('./../lib/slack_message').SlackMessage

module.exports = (robot) ->
  robot.router.post "/github/event", (req, res) ->

    eventReceiver = new GitHubEventReceiver(req)

    if eventReceiver.valid
      eventReceiver.run (message) ->
        if SlackMessage.valid(message)
          robot.adapter.customMessage message

    res.end ""
