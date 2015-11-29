path = require 'path'
program = require 'commander'
yaml = require 'js-yaml'
slidewinder = require '../lib/slidewinder_lib.js'
pjson = require '../package.json'

# Functions for co-ercing command line arguments into suitable formats.
sequencelist = (val) ->
  sequenceAsYaml = ""
  val.split('),').forEach (group) ->
    gsplit = group.split('(')
    groupName = gsplit[0]
    groupSlides = gsplit[1].replace(/\)/g, '')
    slidesAsYaml = "  - - " + groupSlides.replace(/\,/g, "\n    - ")
    groupAsYaml = "- - #{groupName}\n#{slidesAsYaml}\n"
    sequenceAsYaml = sequenceAsYaml + groupAsYaml
  yaml.load(sequenceAsYaml)

colonlist = (val) ->
  yaml.load(val.replace(/:/g, ': ').replace(/,/g, '\n'))

fwpath = (framework) ->
    path.resolve(__dirname, "../extensions/frameworks", framework)

program
.version(pjson.version)
.option('-s, --slides <slide list>',
        'Comma-separated list of slides to use (no spaces)', sequencelist)
.option('-c, --collections <path list>',
        'Comma-separated list of paths to slide collections (no spaces)', colonlist)
.option('-o, --output <path>',
        'Path to save output (will create directory)')
.option('-t, --title <title>', 'Title of the deck')
.option('-a, --author <name>', 'Deck author')
.option('-f, --framework <framework>',
        'HTML and JS Framework or plugin to use for slideshow generation.',
        fwpath)
.parse process.argv

unless process.argv.slice(2).length then program.help()

program.framework ?= fwpath 'remark'

slidewinder program
