chalk = require 'chalk'
inquirer = require 'inquirer'

display_after = [
  { type: 'confirm', message: 'Present the new deck now?', name: 'present' }
]

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
      app.slidewinder.presentDeck(opts.deck) if choice.present
      app.navigate 'manage_library'
  true

module.exports = (app, opts) ->
  findSlides = app.slidewinder.librarian.findSlidesPromise

  basic = [
    { message: 'Name for this deck', name: 'name' }
    { message: 'Author', name: 'author', default: app.config.get('fullname') }
    { message: "Tags (comma separated e.g. 'one, two, three')", name: 'tags' }
  ]

  slidesearch = [
    {
      type: 'autocomplete', name: 'slide',
      message: 'Type a search query and hit enter',
      source: (answers, input) -> findSlides(input)
    },
    { type: 'confirm', message: 'Add another slide?', name: 'add_more' }
  ]

  questions = if opts?.deck then slidesearch else basic.concat(slidesearch)

  inquirer.prompt questions, (answer) -> handle_answer(answer, app, opts)
