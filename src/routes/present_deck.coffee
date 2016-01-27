chalk = require 'chalk'
inquirer = require 'inquirer'

handle_answer = (answer, app, opts={}) ->
  if Object.keys(opts).length is 0
    opts.deck =
      name: answer.name
      author: answer.author
      tags: answer.tags.split(', ')
      slides: [answer.slide]
  else if opts?.deck
    opts.deck.slides.push answer.slide

  if answer.add_more
    app.navigate('create_deck', opts)
  else
    app.slidewinder.librarian.createDeck(opts.deck)
    msg = "Deck #{opts.deck.name} created with " +
          "#{opts.deck.slides.length} slides"
    console.log chalk.yellow('i ') + chalk.bold.white(msg)
    inquirer.prompt display_after, (choice) ->
      app.slidewinder.present(deck) if choice.present
      app.navigate 'manage_library'
  true

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
