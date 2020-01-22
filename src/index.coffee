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
      if context.response.message.text.startsWith(robot.name.toLowerCase())
        context.response.reply 'Sorry, ' + robot.name + ' is not supported on this channel'
      context.response.message.finish()
      done()
    else
      next(done)
