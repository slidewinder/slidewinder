chalk = require 'chalk'
inquirer = require 'inquirer'
autocomplete = require 'inquirer-autocomplete-prompt'
inquirer.registerPrompt('autocomplete', autocomplete)

module.exports = (app, opts={}) ->

  librarian = app.slidewinder.librarian

  actions = [
    { name: 'Add to deck', value: 'add_to_deck' }
    new inquirer.Separator()
    { name: 'Cancel', value: 'cancel' }
  ]

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
    choices: actions

  inquirer.prompt [search_q], (selected) ->
    inquirer.prompt [actions_q], (answer) ->
      if answer.action is 'add_to_deck'
        opts.add_to_deck.slides.push(answer.slide) if opts.add_to_deck
        app.navigate('create_deck', opts.add_to_deck)
      if answer.action is 'cancel'
        app.navigate 'manage_library'
