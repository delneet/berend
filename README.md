# Berend

Berend is a chat bot built on the Hubot framework. It is used to notify developers at Websend with relevant information about PR's and build statuses in Slack.

Berend is currently maintained by @delneet and @wesleydebruijn

## ⚠️ Berend is archived

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

## Configuration
Berend can easily be deployed on a free Heroku instance. Only the GitHub repository needs to be connected in Heroku and you're good to go.

### Environment variables
The following environment variables are required to run Berend. See .env.example for an example.

```
HEROKU_URL
HUBOT_GITHUB_EVENT_NOTIFIER_ROOM    // Name of global chatroom in Slack
HUBOT_GITHUB_EVENT_NOTIFIER_TYPES   // Accepted GitHub events
HUBOT_GITHUB_USERS                  // Mapping of GitHub/Slack users (wesleydebruijn:wesley)
HUBOT_HEROKU_KEEPALIVE_URL          // Heroku URL
HUBOT_SLACK_BOTNAME                 // Slack name
HUBOT_SLACK_TEAM                    // Slack team name
HUBOT_SLACK_TOKEN                   // Token to get access to Slack
TZ                                  // Timezone

```

### Webhooks
Webhooks need to be configured in the desired repositories to make Berend aware of any activity in these repositories.
