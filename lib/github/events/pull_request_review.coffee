SlackMessage = require('./../lib/slack_message').SlackMessage
User = require('./../zuidlaren/user').User

module.exports =
  pull_request_review: (data, callback) ->
    msg = {}
    repo = data.repository
    review = data.review
    pull_req = data.pull_request
    pull_req_owner = slackUser pull_req.user.login
    pull_req_reviewer = slackUser review.user.login

    user_exists = userExists pull_req_owner
    if pull_req.user.login != review.user.login && user_exists
      msg = SlackMessage.create(
        repo.full_name,
        pull_req.title,
        review.html_url,
        "#{pull_req_reviewer} heeft een review geplaatst op je Pull Request",
        pull_req_owner
      )

    callback msg
