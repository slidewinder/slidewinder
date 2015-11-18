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


class PresentationFramework
    constructor: (framework) ->
        log.info 'Looking for presentation framework module: ', framework
        @template = fs.readFileSync path.join(framework, 'template.html'), 'utf8'
        @renderer = handlebars.compile @template
        @helpers = require path.join framework, 'helpers.js'
        @render_deck = (data) =>
            Object.keys(@helpers).forEach (key) =>
                handlebars.registerHelper key, @helpers[key]
                @renderer(data)
        @


# Save a rendered slide deck
save_deck = (deck, data) ->
    mkdirp data.output

    # Write deck
    deckpath = path.resolve data.output, 'index.html'
    fs.writeFileSync deckpath, deck

    # Write slidewinder data
    datapath = path.resolve data.output, 'deck.json'
    fs.writeFileSync datapath, JSON.stringify(data, null, 2)
    msg = 'Deck (index.html) and Data (deck.json) saved to '
    log.info msg, data.output


# Function executes the main slidewinder flow.
slidewinder = (sessiondata) ->
    # Load the slides, and select the ones desired.
    allslides = load_collection sessiondata.collection
    sessiondata.slideset = pick_slides allslides, sessiondata.slides

    # Load the Plugin for the framework that will be used.
    plugin = new PresentationFramework(sessiondata.framework)

    # Render and save
    deck = plugin.render_deck sessiondata

    save_deck(deck, sessiondata)


log = logger()

module.exports = slidewinder
