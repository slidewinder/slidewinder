chalk = require 'chalk'
inquirer = require 'inquirer'
autocomplete = require 'inquirer-autocomplete-prompt'
inquirer.registerPrompt('autocomplete', autocomplete)

default_actions = [
  { name: 'Edit', value: 'edit_slide' }
  { name: 'Add tags', value: 'add_tags' }
  { name: 'Add to collecton', value: 'add_to_collection' }
  { name: 'Add to deck', value: 'add_to_deck' }
]

escape_choices =  [
  new inquirer.Separator()
  { name: 'Go back', value: 'home' }
  { name: 'Exit', value: 'exit' }
]

module.exports = (app, options={}) ->

  choices = [
    { name: 'Import slides', value: 'import_slides' }
    { name: 'Create slide', value: 'create_slide' }
  ]

  # can't search if there are no slides
  if app.slidewinder.librarian.size()
    choices.push { name: 'Search slides', value: 'search' }

  choices = choices.concat escape_choices

  first_q =
    type: 'list'
    name: 'action'
    message: 'What would you like to do?'
    choices: choices


  librarian = app.slidewinder.librarian

  # provide an autocomplete-style search
  search_q =
    type: 'autocomplete'
    name: 'slide'
    message: 'Start typing to search your slides'
    source: (answers, input) ->
      librarian.slideQueryAutocomplete input

  # and the actions for a selected slide
  actions_q =
    type: 'list'
    name: 'action'
    message: 'What do you want to do with this slide?'
    choices: default_actions

  inquirer.prompt [first_q], (chosen) ->
    if chosen.action is 'search'
      inquirer.prompt [search_q], (selected) ->
        inquirer.prompt [actions_q], (answer) ->
          slide = librarian.slideByID selected.slide.id
          app.log.info slide
    else
      app.navigate chosen.action
