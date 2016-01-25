chalk = require 'chalk'
inquirer = require 'inquirer'

choices = [
  { name: 'Manage slides', value: 'search_slides' }
  { name: 'Create a new collection', value: 'create_collection' }
  { name: 'Manage collections', value: 'search_collections' }
  new inquirer.Separator()
  { name: 'Go back', value: 'home' }
  { name: 'Exit', value: 'exit' }
]

module.exports = (app) ->

  msg = "What would you like to do?"

  promptSetup =
    name: 'destination'
    type: 'list'
    message: msg
    choices: choices

  inquirer.prompt promptSetup, (answer) ->
    app.navigate answer.destination
