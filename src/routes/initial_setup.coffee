chalk = require 'chalk'
inquirer = require 'inquirer'

logo = ' ' + chalk.bgYellow('/') + chalk.green('‾◤') +
       chalk.bgCyan('\\') + "\n " + chalk.bgRed('\\') +
       chalk.magenta('◢_') + chalk.bgBlue('/')

module.exports = (app) ->

  msg = "It looks like this is your first time using slidewinder!\n" +
   "  Let's get acquainted. What's your full name?"

  promptSetup =
    name: 'fullname'
    message: msg

  handleAnswer = (answer) ->
    app.config.set('fullname', answer.fullname)
    app.config.set('setup', true)
    app.navigate 'home'

  inquirer.prompt(promptSetup, handleAnswer)
