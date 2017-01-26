# Configuration:
#   HUBOT_WHITELIST
#   HUBOT_WHITELIST_PATH
#   HUBOT_WHITELIST_ALLOW_DM - Allow direct messages

reach = require('hoek').reach
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
    room = reach(context, 'response.envelope.room')
    username = reach(context, 'response.envelope.user.name')

    if HUBOT_WHITELIST_ALLOW_DM and (room is username)
      next(done)
    # Unless the room is in the whitelist
    unless room in whitelist
      # We're done
      context.response.message.finish()
      done()
    else
      next(done)
