chalk = require 'chalk'
inquirer = require 'inquirer'

deck_to_option = (d) -> { name: d.name, value: d, short: d.name }

choose_deck = (app, decks) ->
  inquirer.prompt {
    type: 'list'
    name: 'deck'
    message: "Pick a deck to present"
    choices: decks.map(deck_to_option)
  }, (answer) ->
    app.navigate('present_deck', answer)
  null

module.exports = (app, opts) ->

  frameworks = app.slidewinder.listFrameworks()

  if not opts?.deck
    app.slidewinder.listDecks (err, decks) -> choose_deck(app, decks)
  else
    deckdir = app.slidewinder.presentDeck opts.deck
    console.log chalk.yellow('i ') +
      chalk.bold.white("Deck was written to #{deckdir}")
    console.log chalk.yellow('i ') +
      chalk.bold.white("It should open in your browser momentarily")

  null
