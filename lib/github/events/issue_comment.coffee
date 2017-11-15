SlackMessage = require('./../lib/slack_message').SlackMessage
User = require('./../zuidlaren/user').User
Repository = require('./../zuidlaren/repository').Repository

module.exports =
  issue_comment: (data, callback) ->
    message = {}
    repo = data.repository
    issue = data.issue
    issue_owner = slackUser issue.user.login
    comment = data.comment
    comment_owner = slackUser comment.user.login

    issue_pull = "Issue"

    if comment.html_url.indexOf("/pull/") > -1
      issue_pull = "Pull Request"

    user_exists = userExists issue_owner
    if issue.user.login != comment.user.login && user_exists
      message = SlackMessage.create(
        repo.full_name,
        "#{issue_pull} ##{issue.number}",
        comment.html_url,
        "#{comment_owner} heeft een comment geplaatst op je #{issue_pull}",
        issue_owner
      )

    callback message
