# Configuration:
#   HUBOT_WHITELIST
#   HUBOT_WHITELIST_PATH

reach = require('hoek').reach
path = require('path')

module.exports = (robot) ->

  # Establish whitelist
  robot.logger.info "Creating whitelist"

  whitelist = []
  if process.env.HUBOT_WHITELIST
    whitelist = process.env.HUBOT_WHITELIST.split(',')
  else if process.env.HUBOT_WHITELIST_PATH
    whitelist = require(path.resolve(process.env.HUBOT_WHITELIST_PATH))

  robot.logger.info "These are the users and rooms you are whitelisting #{whitelist}"

  unless Array.isArray(whitelist)
    robot.logger.error 'whitelist is not an array!'

  robot.receiveMiddleware (context, next, done) ->
    # Unless the room is in the whitelist
    robot.logger.debug "Checking whitelist rooms"
    unless reach(context, 'response.envelope.room') in whitelist
      # We're done
      robot.logger.debug "Room not in whitelist"
      context.response.message.finish()
      done()
    else
      robot.logger.debug "Room in whitelist"
      next(done)

    unless reach(context, 'response.envelope.user.name') in whitelist
      # We're donea
      robot.logger.debug "User not in whitelist"
      # console.log(util.inspect(context, false, null))
      context.response.message.finish()
      done()
    else
      robot.logger.debug "User in whitelist"
      next(done)