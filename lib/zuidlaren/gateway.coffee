request = require('request')

class Gateway
  get: (path) ->
    url = "#{process.env['ZUIDLAREN_API']}#{path}.json"
    request.get(url)

module.exports = Gateway
