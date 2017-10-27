# Berend

Berend is a chat bot built on the Hubot framework. It is used to notify developers at Websend with relevant information about PR's and build statuses in Slack.

Berend is currently maintained by @delneet and @wesleydebruijn

## What can Berend do?
Berend is constantly listening to events pushed by GitHub and can send Slack messages in global chatrooms and can also send direct messages to developers.

### Global messages
Berend will notify the general chatroom when:
* a Pull Request or Issue is created by a team member

### Direct messages
Berend will notify a developer directly when:
* a Pull Request needs to be reviewed by him/her
* someone reviewed his/her Pull Request
* someone placed a comment on his/her Pull Request or Issue
* a build is started in Jenkins of his/her commit in a branch
* a build has finished in Jenkins of his/her commit in a branch

### Webhooks
Webhooks need to be configured in the desired repositories to make Berend aware of any activity in these repositories.
