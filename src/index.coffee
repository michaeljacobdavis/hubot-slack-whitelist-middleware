# Configuration:
#   HUBOT_WHITELIST
#   HUBOT_WHITELIST_PATH

reach = require('@hapi/hoek').reach
path = require('path')

module.exports = (robot) ->

  # Establish whitelist
  whitelist = []
  if process.env.HUBOT_WHITELIST
    whitelist = process.env.HUBOT_WHITELIST.split(',')
  else if process.env.HUBOT_WHITELIST_PATH
    whitelist = require(path.resolve(process.env.HUBOT_WHITELIST_PATH))

  unless Array.isArray(whitelist)
    robot.logger.error 'whitelist is not an array!'

  robot.receiveMiddleware (context, next, done) ->
    # Unless the room is in the whitelist
    unless reach(context, 'response.envelope.room') in whitelist
      result = context.response.message.text.search /robot.name\s/
      if result == 0
        context.response.reply 'Sorry, truebot is not supported on this channel'
      context.response.message.finish()
      done()
    else
      next(done)
