module.exports =
  pull_request: (adapter, data, callback) ->
    msg = {}
    repo = data.repository
    pull_req = data.pull_request
    pull_req_sender = data.sender.login

    action = data.action

    switch action
      when "assigned"
        pull_req_assignee = slackUser data.assignee.login
        user_exists = userExists pull_req_assignee
        if data.assignee.login != data.sender.login && user_exists
          msg = createMessage(
            "Wil je hier naar kijken @#{pull_req_assignee}?",
            repo.full_name,
            pull_req.title,
            pull_req.html_url,
            "Pull Request van #{pull_req_sender}"
          )
      when "review_requested"
        pull_req_reviewer = slackUser data.requested_reviewer.login
        user_exists = userExists pull_req_reviewer
        if data.requested_reviewer.login != data.sender.login && user_exists
          msg = createMessage(
            "Wil je hier naar kijken @#{pull_req_reviewer}?",
            repo.full_name,
            pull_req.title,
            pull_req.html_url,
            "Pull Request van #{pull_req_sender}"
          )
      when "opened"
        user_exists = userExists pull_req_sender
        if user_exists
          msg = createMessage(
            "Nieuwe Pull Request",
            repo.full_name,
            pull_req.title,
            pull_req.html_url,
            "Pull Request van #{pull_req_sender}"
          )
  
    callback msg

  pull_request_review: (adapter, data, callback) ->
    msg = {}
    repo = data.repository
    review = data.review
    pull_req = data.pull_request
    pull_req_owner = slackUser pull_req.user.login
    pull_req_reviewer = review.user.login

    user_exists = userExists pull_req_owner
    if pull_req.user.login != review.user.login && user_exists
      msg = createMessage(
        "Er is een review op je Pull Request geplaatst @#{pull_req_owner}",
        repo.full_name,
        pull_req.title,
        review.html_url,
        "Review geplaatst door #{pull_req_reviewer}"
      )

    callback msg

  pull_request_review_comment: (adapter, data, callback) ->
    msg = {}
    repo = data.repository
    comment = data.comment
    pull_req = data.pull_request
    pull_req_owner = slackUser pull_req.user.login
    pull_req_commenter = comment.user.login

    user_exists = userExists pull_req_owner
    if pull_req.user.login != comment.user.login && user_exists
      msg = createMessage(
        "Er is een comment op je Pull Request geplaatst @#{pull_req_owner}",
        repo.full_name,
        pull_req.title,
        comment.html_url,
        "Comment geplaatst door #{pull_req_commenter}"
      )

    callback msg

  issues: (adapter, data, callback) ->
    msg = {}
    repo = data.repository
    issue = data.issue
    issue_sender = data.sender.login

    action = data.action

    switch action
      when "assigned"
        issue_assignee = slackUser issue.assignee.login
        user_exists = userExists issue_assignee
        if issue.assignee.login != data.sender.login && user_exists
          msg = createMessage(
            "Je bent toegewezen aan een Issue @#{issue_assignee}",
            repo.full_name,
            issue.title,
            issue.html_url,
            "Issue van #{issue_sender}"
          )
      when "opened"
        user_exists = userExists issue_sender
        if user_exists
          msg = createMessage(
            "Nieuwe Issue",
            repo.full_name,
            issue.title,
            issue.html_url,
            "Issue van #{issue_sender}"
          )

    callback msg

  issue_comment: (adapter, data, callback) ->
    msg = {}
    repo = data.repository
    issue = data.issue
    issue_owner = slackUser issue.user.login
    comment = data.comment
    comment_owner = comment.user.login
    comment_link = formatUrl adapter, comment.html_url, "#{issue_pull} ##{issue.number}"

    issue_pull = "Issue"

    if comment.html_url.indexOf("/pull/") > -1
      issue_pull = "Pull Request"

    user_exists = userExists issue_owner
    if issue.user.login != comment.user.login && user_exists
      msg = createMessage(
        "Er is een comment geplaatst op je #{issue_pull} @#{issue_owner}",
        repo.full_name,
        "#{issue_pull} ##{issue.number}",
        comment.html_url,
        "Comment geplaatst door #{comment_owner}"
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

createMessage = (pretext, repo, title, link, text) ->
  {
    "color": "#36a64f",
    "pretext": pretext,
    "author_name": repo,
    "title": title,
    "title_link": link,
    "text": text
  }