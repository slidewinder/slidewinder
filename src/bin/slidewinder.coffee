`#!/usr/bin/env node
`

# The slidewinder entry executable.
pjson = require '../package.json'
path = require 'path'
slidewinder = require '../lib/slidewinder.js'
db = require 'linvodb3'

if process.argv.length < 3
  new slidewinder(db).run()
else
  program = require 'commander'

  program
    .version(pjson.version)
    .command('compile', 'compile a presentation from a specification file')
    .parse(process.argv)
