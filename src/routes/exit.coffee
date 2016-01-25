chalk = require 'chalk'


module.exports = (app) ->
  msg = "\n    thanks for using slidewinder :)\n" +
   "     ~ the slidewinder team\n" +
   "    -> http://slidewinder.io\n"

  console.log chalk.bold.white(msg)
  # process.exit(0)
