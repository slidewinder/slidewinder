`#!/usr/bin/env node
`

# The slidewinder entry executable.
pjson = require '../package.json'
path = require 'path'
program = require 'commander'
yaml = require 'js-yaml'

program
  .version(pjson.version)
  .command('compile', 'compile a presentation from a specification file')
  .parse(process.argv)

# Functions for co-ercing command line arguments into suitable formats.
#sequencelist = (val) ->
#  sequenceAsYaml = ""
#  val.split('),').forEach (group) ->
#    gsplit = group.split('(')
#    groupName = gsplit[0]
#    groupSlides = gsplit[1].replace(/\)/g, '')
#    slidesAsYaml = "  - - " + groupSlides.replace(/\,/g, "\n    - ")
#    groupAsYaml = "- - #{groupName}\n#{slidesAsYaml}\n"
#    sequenceAsYaml = sequenceAsYaml + groupAsYaml
#  yaml.load(sequenceAsYaml)
#
#colonlist = (val) ->
#  yaml.load(val.replace(/:/g, ': ').replace(/,/g, '\n'))
#
#fwpath = (framework) ->
#    framework ?= 'remark'
#    path.resolve(__dirname, "../extensions/frameworks", framework)
#
#parseSpecification = (path) ->
#  specification = yaml.load(path)
#
