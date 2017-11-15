SlackMessage = require('./../lib/slack_message').SlackMessage
User = require('./../zuidlaren/user').User

module.exports =
  pull_request_review_comment: (data, callback) ->
    msg = {}
    repo = data.repository
    comment = data.comment
    pull_req = data.pull_request
    pull_req_owner = slackUser pull_req.user.login
    pull_req_commenter = slackUser comment.user.login

    user_exists = userExists pull_req_owner
    if pull_req.user.login != comment.user.login && user_exists
      msg = SlackMessage.create(
        repo.full_name,
        pull_req.title,
        comment.html_url,
        "#{pull_req_commenter} heeft een comment geplaatst op je Pull Request",
        pull_req_owner
      )

    callback msg
