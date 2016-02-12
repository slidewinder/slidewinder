`#!/usr/bin/env node
`

# Command line utility to compile a slidewinder slideshow, from a specification
# file.

program = require 'commander'
slidewinder = require '../lib/slidewinder.js'

program
  .option('-i, --input <file>',
          'Specification file to use to compile slideshow')
  .option('-o, --output <file>',
          'Folder to save slideshow to')
  .parse(process.argv)

if program.input and program.output
  @slidewinder.librarian.compile(program.input, program.output)
  process.exit(0)
else
  program.help()
