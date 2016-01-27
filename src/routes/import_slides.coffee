chalk = require 'chalk'
inquirer = require 'inquirer'
path = require 'path'
inquirer.prompt.registerPrompt('directory', require('inquirer-directory'))

module.exports = (app) ->

  inquirer.prompt [{
    type: "directory"
    message: "Choose directory of slides to import"
    name: "path"
    absolute: true
    basePath: '.'
  },
  {
    message: "Name for this collection"
    name: "name"
  }],
  (ans) ->
    ans.abspath = path.resolve(ans.path)

    console.log chalk.yellow('i ') +
                chalk.bold.white("Loading directory #{ans.abspath}")
    c = app.slidewinder.librarian.addByPath(ans.abspath, ans.name)
    msg = "Imported #{c.size()} slides and added them to a new collection."

    console.log chalk.yellow('i ') + chalk.bold.white(msg)

    app.navigate 'manage_library'
