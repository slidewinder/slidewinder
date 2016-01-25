chalk = require 'chalk'
inquirer = require 'inquirer'

choices = [
  { name: 'Import slides', value: 'import_slides' }
  { name: 'Create slide', value: 'create_slide' }
  { name: 'Search slides', value: 'search_slides' }
  new inquirer.Separator()
  { name: 'Create a new collection', value: 'create_collection' }
  { name: 'Manage collections', value: 'search_collections' }
  new inquirer.Separator()
  { name: 'Go back', value: 'home' }
  { name: 'Exit', value: 'exit' }
]

module.exports = (app) ->

  # can't search if there are no slides
  _choices = choices
  if app.slidewinder.librarian.size()
    _choices = _choices.filter (c) -> c.value? not 'search_slides'
  else
    n_slides = app.slidewinder.librarian.size()
    n_cols = app.slidewinder.librarian.collections.length or 0
    msg = "You have #{n_slides} slides in #{n_cols} collections"
    console.log(chalk.yellow("i"),
                chalk.bold.white(msg))

  msg = "What would you like to do?"

  promptSetup =
    name: 'destination'
    type: 'list'
    message: msg
    choices: choices

  inquirer.prompt promptSetup, (answer) ->
    app.navigate answer.destination
