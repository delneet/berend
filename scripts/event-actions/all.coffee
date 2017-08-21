module.exports =
  pull_request: (adapter, data, callback) ->
    msg = ""
    repo = data.repository
    pull_req = data.pull_request
    pull_req_sender = data.sender.login
    pull_request_link = formatUrl adapter, pull_req.html_url, "##{data.number} \"#{pull_req.title}\""

    action = data.action

    switch action
      when "assigned"
        pull_req_assignee = slackUser data.assignee.login
        user_exists = userExists pull_req_assignee
        if data.assignee.login != data.sender.login && user_exists
          msg = "Zou je voor #{pull_req_sender} naar deze Pull Request in *#{repo.name}* willen kijken @#{pull_req_assignee}? (#{pull_request_link})"
      when "review_requested"
        pull_req_reviewer = slackUser data.requested_reviewer.login
        user_exists = userExists pull_req_reviewer
        if data.requested_reviewer.login != data.sender.login && user_exists
          msg = "Zou je voor #{pull_req_sender} naar deze Pull Request in *#{repo.name}* willen kijken @#{pull_req_reviewer}? (#{pull_request_link})"
      when "opened"
        msg = "#{pull_req_sender} heeft een nieuwe Pull Request gemaakt in *#{repo.name}* (#{pull_request_link})"
  
    callback msg

  pull_request_review: (adapter, data, callback) ->
    msg = ""
    review = data.review
    pull_req = data.pull_request
    pull_req_owner = slackUser pull_req.user.login
    pull_req_reviewer = review.user.login
    review_link = formatUrl adapter, review.html_url, pull_req.title

    user_exists = userExists pull_req_owner
    if pull_req.user.login != review.user.login && user_exists
      msg = "#{pull_req_reviewer} heeft een review geplaatst bij je Pull Request @#{pull_req_owner} (#{review_link})"

    callback msg

  pull_request_review_comment: (adapter, data, callback) ->
    msg = ""
    comment = data.comment
    pull_req = data.pull_request
    pull_req_owner = slackUser pull_req.user.login
    pull_req_commenter = comment.user.login
    comment_link = formatUrl adapter, comment.html_url, pull_req.title

    user_exists = userExists pull_req_owner
    if pull_req.user.login != comment.user.login && user_exists
      msg = "#{pull_req_commenter} heeft een comment geplaatst bij je Pull Request @#{pull_req_owner} (#{comment_link})"

    callback msg

  issues: (adapter, data, callback) ->
    msg = ""
    repo = data.repository
    issue = data.issue
    issue_link = formatUrl adapter, issue.html_url, "##{issue.number} \"#{issue.title}\""
    issue_sender = data.sender.login

    action = data.action

    switch action
      when "assigned"
        issue_assignee = slackUser issue.assignee.login
        user_exists = userExists issue_assignee
        if issue.assignee.login != data.sender.login && user_exists
          msg = "#{issue_sender} heeft je toegewezen aan een Issue in *#{repo.name}* @#{issue_assignee} (#{issue_link})"
      when "opened"
        msg = "#{issue_sender} heeft een nieuwe Issue gemaakt in *#{repo.name}* (#{issue_link})"

    callback msg

  issue_comment: (adapter, data, callback) ->
    msg = ""
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
      msg = "#{comment_owner} heeft een comment geplaatst bij je #{issue_pull} @#{issue_owner} (#{comment_link})"

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
