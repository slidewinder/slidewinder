chalk = require 'chalk'
inquirer = require 'inquirer'
autocomplete = require 'inquirer-autocomplete-prompt'
inquirer.registerPrompt('autocomplete', autocomplete)

default_actions = [
  { name: 'Edit', value: 'edit_slide' }
  { name: 'Add tags', value: 'add_tags' }
  { name: 'Add to collecton', value: 'add_to_collection' }
  { name: 'Add to deck', value: 'add_to_deck' }
  new inquirer.Separator()
  { name: 'Cancel', value: 'cancel' }
]

module.exports = (app, options={}) ->

  librarian = app.slidewinder.librarian

  # provide an autocomplete-style search
  search_q =
    type: 'autocomplete'
    name: 'slide'
    message: 'Type a search query and hit enter'
    source: (answers, input) -> librarian.findSlidesPromise(input)

  # and drop-down actions for a selected slide
  actions_q =
    type: 'list'
    name: 'action'
    message: 'What do you want to do with this slide?'
    choices: default_actions

  inquirer.prompt [search_q], (selected) ->
    inquirer.prompt [actions_q], (answer) ->
      app.navigate 'search_slides'
