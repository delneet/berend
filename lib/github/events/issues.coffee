SlackMessage = require('./../lib/slack_message').SlackMessage
User = require('./../zuidlaren/user').User
Repository = require('./../zuidlaren/repository').Repository

module.exports =
  issues: (data, callback) ->
    message = {}
    repo = data.repository
    issue = data.issue
    issue_sender = slackUser data.sender.login

    action = data.action

    switch action
      when "assigned"
        issue_assignee = slackUser issue.assignee.login
        user_exists = userExists issue_assignee
        if issue.assignee.login != data.sender.login && user_exists
          message = SlackMessage.create(
            repo.full_name,
            issue.title,
            issue.html_url,
            "Je bent toegewezen aan een Issue van #{issue_sender}",
            issue_assignee
          )
      when "opened"
        user_exists = userExists issue_sender
        if user_exists
          message = SlackMessage.create(
            repo.full_name,
            issue.title,
            issue.html_url,
            "Nieuwe Issue aangemaakt door #{issue_sender}"
          )

    callback message
