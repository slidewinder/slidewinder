
program = require 'commander'
path = require 'path'
slidewinder = require '../lib/slidewinder_lib.js'

pjson = require '../package.json'

# Functions for co-ercing command line arguments into suitable formats.
list = (val) ->
    val.split ','


fwpath = (framework) ->
    path.resolve __dirname, "../extensions/frameworks", framework


program
.version(pjson.version)
.option('-s, --slides <slide list>',
        'Comma-separated list of slides to use (no spaces)', list)
.option('-c, --collection <path>',
        'Path to slide collection')
.option('-o, --output <path>',
        'Path to save output (will create directory)')
.option('-t, --title <title>', 'Title of the deck')
.option('-a, --author <name>', 'Deck author')
.option('-f, --framework <framework>',
        'HTML and JS Framework or plugin to use for slideshow generation.', fwpath)
.parse process.argv

unless process.argv.slice(2).length then program.help()

program.framework ?= fwpath 'remark'

slidewinder program
