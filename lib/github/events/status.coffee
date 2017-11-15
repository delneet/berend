SlackMessage = require('./../lib/slack_message').SlackMessage
User = require('./../zuidlaren/user').User

module.exports =
  status: (data, callback) ->
    msg = {}
    repo = data.repository
    state = data.state
    color = buildStatusColor state
    branch_name = data.branches[0].name
    build_starter = slackUser data.commit.committer.login

    user_exists = userExists build_starter
    if user_exists
      msg = SlackMessage.create(
        repo.full_name,
        "Jenkins: #{branch_name}",
        data.target_url,
        data.description,
        build_starter,
        color
      )

    callback msg

buildStatusColor = (state) ->
  switch state
    when "success"
      return "#36a64f"
    when "failed" || "error"
      return "#ff0000"
    when "pending"
      return "#FFA500"
