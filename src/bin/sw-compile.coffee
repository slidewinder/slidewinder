`#!/usr/bin/env node
`

# Command line utility to compile a slidewinder slideshow, from a specification
# file.

program = require 'commander'
sw = require '../lib/slidewinder_lib.js'

program
  .option('-i, --input <file>', 'Specification file to use to compile slideshow')
  .option('-o, --output <file>', 'Folder to save slideshow to')
  .parse(process.argv)

if program.input and program.output
  program.specification = sw.yamlToSpec program.input
  sw.compile(program.specification, program.output)
  process.exit()
else
  program.help()
