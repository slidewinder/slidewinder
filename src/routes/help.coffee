chalk = require 'chalk'
inquirer = require 'inquirer'
open = require 'open'

choices = [
  # { name: 'Create a slide', value: 'create_slide' }
  { name: 'Learn how to use slidewinder', value: 'learn' }
  { name: 'Chat to slidewinder users and team', value: 'chat' }
  { name: 'Report a bug', value: 'bug' }
  { name: 'Go back', value: 'home' }
  { name: 'Exit', value: 'exit' }
]

help_urls =
  learn: 'http://slidewinder.io/help'
  bug: 'https://github.com/slidewinder/slidewinder/issues'
  chat: 'https://gitter.im/slidewinder/slidewinder'

module.exports = (app) ->

  msg = "How can we help?"

  promptSetup =
    name: 'problem'
    type: 'list'
    message: msg
    choices: choices

  handleAnswer = (answer) ->
    if answer.problem in ['learn', 'chat', 'bug']
      open help_urls[answer.problem]
      app.navigate 'home'
    else
      app.navigate answer.problem

  inquirer.prompt(promptSetup, handleAnswer)
