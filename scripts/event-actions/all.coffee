module.exports =
  pull_request: (adapter, data, callback) ->
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
          msg = createMessage(
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
          msg = createMessage(
            repo.full_name,
            pull_req.title,
            pull_req.html_url,
            "Wil je naar de Pull Request van #{pull_req_sender} kijken?",
            pull_req_reviewer
          )
      when "opened"
        user_exists = userExists pull_req_sender
        if user_exists
          msg = createMessage(
            repo.full_name,
            pull_req.title,
            pull_req.html_url,
            "Nieuwe Pull Request aangemaakt door #{pull_req_sender}"
          )
  
    callback msg

  pull_request_review: (adapter, data, callback) ->
    msg = {}
    repo = data.repository
    review = data.review
    pull_req = data.pull_request
    pull_req_owner = slackUser pull_req.user.login
    pull_req_reviewer = slackUser review.user.login

    user_exists = userExists pull_req_owner
    if pull_req.user.login != review.user.login && user_exists
      msg = createMessage(
        repo.full_name,
        pull_req.title,
        review.html_url,
        "#{pull_req_reviewer} heeft een review geplaatst op je Pull Request",
        pull_req_owner
      )

    callback msg

  pull_request_review_comment: (adapter, data, callback) ->
    msg = {}
    repo = data.repository
    comment = data.comment
    pull_req = data.pull_request
    pull_req_owner = slackUser pull_req.user.login
    pull_req_commenter = slackUser comment.user.login

    user_exists = userExists pull_req_owner
    if pull_req.user.login != comment.user.login && user_exists
      msg = createMessage(
        repo.full_name,
        pull_req.title,
        comment.html_url,
        "#{pull_req_commenter} heeft een comment geplaatst op je Pull Request",
        pull_req_owner
      )

    callback msg

  issues: (adapter, data, callback) ->
    msg = {}
    repo = data.repository
    issue = data.issue
    issue_sender = slackUser data.sender.login

    action = data.action

    switch action
      when "assigned"
        issue_assignee = slackUser issue.assignee.login
        user_exists = userExists issue_assignee
        if issue.assignee.login != data.sender.login && user_exists
          msg = createMessage(
            repo.full_name,
            issue.title,
            issue.html_url,
            "Je bent toegewezen aan een Issue van #{issue_sender}",
            issue_assignee
          )
      when "opened"
        user_exists = userExists issue_sender
        if user_exists
          msg = createMessage(
            repo.full_name,
            issue.title,
            issue.html_url,
            "Nieuwe Issue aangemaakt door #{issue_sender}"
          )

    callback msg

  issue_comment: (adapter, data, callback) ->
    msg = {}
    repo = data.repository
    issue = data.issue
    issue_owner = slackUser issue.user.login
    comment = data.comment
    comment_owner = slackUser comment.user.login
    comment_link = formatUrl adapter, comment.html_url, "#{issue_pull} ##{issue.number}"

    issue_pull = "Issue"

    if comment.html_url.indexOf("/pull/") > -1
      issue_pull = "Pull Request"

    user_exists = userExists issue_owner
    if issue.user.login != comment.user.login && user_exists
      msg = createMessage(
        repo.full_name,
        "#{issue_pull} ##{issue.number}",
        comment.html_url,
        "#{comment_owner} heeft een comment geplaatst op je #{issue_pull}",
        issue_owner
      )

    callback msg

slackUser = (username) ->
  for user in process.env['HUBOT_GITHUB_USERS'].split(',')
    do ->
    parts = user.split(":")
    github_user = parts[0]
    slack_user = parts[1]
    if github_user == username
      return slack_user
  username

userExists = (username) ->
  process.env['HUBOT_GITHUB_USERS'].indexOf(username) > -1

formatUrl = (adapter, url, text) ->
  switch adapter
    when "mattermost" || "slack"
      "<#{url}|#{text}>"
    else
      url

createMessage = (repo, title, link, text, room) ->
  default_room = process.env["HUBOT_GITHUB_EVENT_NOTIFIER_ROOM"]
  {
    channel: room || default_room, 
    attachments: [{
      "color": "#36a64f",
      "author_name": repo,
      "title": title,
      "title_link": link,
      "text": text
    }] 
  }