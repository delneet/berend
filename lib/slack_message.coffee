class SlackMessage
  create: (author, title, link, text, room, color) ->
    {
      channel: room,
      attachments: [{
        "color": color || "#3AA3E3",
        "author_name": author,
        "title": title,
        "title_link": link,
        "text": text
      }]
    }

  valid: (message) ->
    Object.keys(message).length > 0


module.exports.SlackMessage = SlackMessage
