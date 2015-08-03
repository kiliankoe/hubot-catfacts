# Description
#   Subscribe to Cat Facts
#
# Configuration:
#   HUBOT_CATFACTS_FACTINTERVAL: When to send out cat facts, uses cron syntax and defaults to '00 00 * * * *' (hourly)
#
# Commands:
#   hubot catfact - subscribe yourself to Cat Facts. Thanks for using Cat Facts!
#
# Author:
#   Kilian Koeltzsch <me@kilian.io>

cronjob = require("cron").CronJob
catfactsinterval = process.env.HUBOT_CATFACTS_FACTINTERVAL or "*/5 * * * * *"

module.exports = (robot) ->

  new cronjob(catfactsinterval, ->
    subscribers = robot.brain.get("catfactusers")
    unless subscribers == null
      subscribers = subscribers.split("|")
      for subscriber in subscribers
        sendCatFact subscriber
  , null, true, "Europe/Berlin")

  robot.hear /foobar/, (res) ->
    subscribers = robot.brain.get("catfactusers")
    console.log(subscribers)

  robot.respond /catfact/i, (res) ->
    user = res.envelope.user.name
    subscribeUser user

    robot.send {room: user}, "You have now been subscribed to Cat Facts. Type 'cancel' to unsubscribe."
    sendCatFact user

  robot.respond /cancel|unsubscribe|a+h/i, (res) ->
    user = res.envelope.user.name
    if isUserSubscribed(user)
      res.send "Command not recognized. You have a 2 year subscription to Cat Facts and will receive fun hourly updates!"
      unsubscribeUser user
      setTimeout () ->
        sendCatFact user
      , 3600 * 1000
    else
      robot.send {room: user}, "You have now been subscribed to Cat Facts. Type 'cancel' to unsubscribe."
      subscribeUser user


  sendCatFact = (user) ->
    robot.http('http://catfacts-api.appspot.com/api/facts?number=1')
      .get() (error, res, body) ->
        response = JSON.parse(body)
        if response.success == "true"
          robot.send {room: user}, response.facts[0] + " Thanks for using Cat Facts!"
        else
          robot.send {room: user}, "Cat Facts will be back shortly. Thanks for using Cat Facts!"

  subscribeUser = (user) ->
    # I don't give a fuck about redis lists. String is love, string is life.
    subscribers = robot.brain.get("catfactusers")
    if subscribers == null
      robot.brain.set "catfactusers", user
    else
      subscribers = subscribers.split("|")
      unless subscribers.indexOf(user) > -1
        subscribers += user
        robot.brain.set "catfactusers", subscribers.join("|")

  unsubscribeUser = (user) ->
    subscribers = robot.brain.get("catfactusers") or ""
    subscribers = subscribers.split("|")
    list = []
    for subscriber in subscribers
      unless subscriber == user
        list += user
    robot.brain.set "catfactusers", list.join("|")

  isUserSubscribed = (user) ->
    subscribers = robot.brain.get("catfactusers") or ""
    return subscribers.indexOf(user) > -1
