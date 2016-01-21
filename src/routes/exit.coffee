chalk = require 'chalk'

logo = ' ' + chalk.yellow('/') + chalk.green('‾◤') +
       chalk.cyan('\\') + "\n " + chalk.red('\\') +
       chalk.magenta('◢_') + chalk.blue('/')

module.exports = (app) ->
  msg = "#{logo} thanks for using slidewinder :)\n" +
   "      ~ the slidewinder team\n" +
   "     -> http://slidewinder.io"

  console.log chalk.yellow(msg)
  process.exit(0)
