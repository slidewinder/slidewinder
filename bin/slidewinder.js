#!/usr/bin/env node
var program = require('commander')
  , slidewinder = require('../lib/slidewinder.js');

var pjson = require('../package.json');

program
.version(pjson.version)
.option('-s, --slides <slide list>',
        'Comma-separated list of slides to use (no spaces)')
.option('-c, --collection <path>',
        'Path to slide collection')
.option('-o, --output <path>',
        'Path to save output (will create directory)')
.option('-t, --title <title>', 'Title of the deck')
.option('-a, --author <name>', 'Deck author')
.parse(process.argv);

if (!process.argv.slice(2).length) {
  program.help();
}

slidewinder(program);
