chalk = require 'chalk'
inquirer = require 'inquirer'

choices = [
  { name: 'Create a slide', value: 'create_slide' }
  { name: 'Create a deck', value: 'create_deck' }
  { name: 'Present a deck', value: 'present_deck' }
  { name: 'Manage your slide library', value: 'manage_library' }
  { name: 'Get help', value: 'help' }
  { name: 'Exit', value: 'exit' }
]

module.exports = (app) ->

  if app.config.get('setup')
    greet = "Oh hai #{chalk.blue(app.config.get('fullname'))}!"
    msg = "#{greet} What would you like to do?"

    promptSetup =
      name: 'destination'
      type: 'list'
      message: msg
      choices: choices

    handleAnswer = (answer) ->
      unless answer.destination is 'exit'
        app.navigate answer.destination

    inquirer.prompt(promptSetup, handleAnswer)
  else
    app.navigate('initial_setup')
