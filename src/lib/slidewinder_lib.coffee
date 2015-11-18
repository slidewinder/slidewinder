# Slidewinder-Lib.

fs = require 'fs'
path = require 'path'
fm = require 'front-matter'
handlebars = require 'handlebars'
_ = require 'lodash'
mkdirp = require 'mkdirp'
logger = require './log.js'
yaml = require 'js-yaml'


log_colours =
    silly: 'magenta'
    input: 'grey'
    verbose: 'cyan'
    prompt: 'grey'
    debug: 'blue'
    info: 'green'
    data: 'grey'
    help: 'cyan'
    warn: 'yellow'
    error: 'red'


# Load a Markdown format slide collection
load_collection = (dirpath) ->
    collection = {}
    # Load each slide, parse the frontmatter, and collect.
    fs.readdirSync(dirpath).forEach (file) ->
        filepath = path.resolve dirpath, file
        data = fs.readFileSync filepath, 'utf8'
        slide = fm data
        name = slide.attributes.name
        if collection[name]
            log.error 'Multiple slides have the name', name
        else
            collection[name] = slide
    log.info 'Loaded', Object.keys(collection).length, 'markdown slide files from', dirpath
    collection


pick_slides = (collection, selections) ->
    picked = []
    selections.forEach (selection) ->
        slide = collection[selection]
        if slide
            picked.push slide
        else
            log.error 'No slide found with name', name
    log.info 'Picked', picked.length, 'slides from collection'
    picked


PresentationFramework = (framework) ->
    log.info 'Looking for presentation framework module: ', framework
    fw = @
    template = fs.readFileSync path.join(framework, 'template.html'), 'utf8'
    #fw.renderer = handlebars.compile template
    fw.helpers = require path.join framework, 'helpers.js'
    fw.render_deck = (data) ->
        fw.renderer(data)
    fw


# A Framework can...
# Register helpers for use in the handlebars HTML template.
PresentationFramework.registerHelpers = () ->
    fw = @
    Object.keys(fw.helpers).forEach (key) ->
        handlebars.registerHelper key, fw.helpers[key]


# Function executes the main slidewinder flow.
slidewinder = (sessiondata) ->
    # Load the slides, and select the ones desired.
    allslides = load_collection sessiondata.collection
    sessiondata.slideset = pick_slides allslides, sessiondata.slides

    # Load the Plugin for the framework that will be used.
    plugin = PresentationFramework(sessiondata.framework)

    console.log plugin

    # Render and save
    # deck = renderer(sessiondata)
    process.exit()
    deck = plugin.render_deck sessiondata

    save_deck(deck, data)


log = logger()

module.exports = slidewinder
