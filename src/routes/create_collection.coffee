chalk = require 'chalk'
inquirer = require 'inquirer'
collection = require '../lib/collection.js'

questions = [
  { message: 'Name of the collection', name: 'name' }
  { message: 'Description', name: 'description' }
  { message: 'Tags (space separated)', name: 'tags' }
]

module.exports = (app) ->
  inquirer.prompt questions, (answers) ->
    answers.tags = answers.tags.trim().split ' '
    app.slidewinder.librarian.add(new collection(answers))
    app.route 'manage_library'
