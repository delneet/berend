SlackMessage = require('./../lib/slack_message').SlackMessage
User = require('./../zuidlaren/user').User
Repository = require('./../zuidlaren/repository').Repository

module.exports =
  pull_request: (data, callback) ->
    msg = {}
    repo = data.repository
    pull_req = data.pull_request
    pull_req_sender = slackUser data.sender.login

    action = data.action

    switch action
      when "assigned"
        pull_req_assignee = slackUser data.assignee.login
        user_exists = userExists pull_req_assignee
        if data.assignee.login != data.sender.login && user_exists
          msg = SlackMessage.create(
            repo.full_name,
            pull_req.title,
            pull_req.html_url,
            "Wil je naar de Pull Request van #{pull_req_sender} kijken?",
            pull_req_assignee
          )
      when "review_requested"
        pull_req_reviewer = slackUser data.requested_reviewer.login
        user_exists = userExists pull_req_reviewer
        if data.requested_reviewer.login != data.sender.login && user_exists
          msg = SlackMessage.create(
            repo.full_name,
            pull_req.title,
            pull_req.html_url,
            "Wil je naar de Pull Request van #{pull_req_sender} kijken?",
            pull_req_reviewer
          )
      when "opened"
        user_exists = userExists pull_req_sender
        if user_exists
          msg = SlackMessage.create(
            repo.full_name,
            pull_req.title,
            pull_req.html_url,
            "Nieuwe Pull Request aangemaakt door #{pull_req_sender}"
          )

    callback msg
