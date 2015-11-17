/// Slidewinder-Lib.

var fs = require('fs'),
    path = require('path'),
    fm = require('front-matter'),
    handlebars = require('handlebars'),
    _ = require('lodash'),
    mkdirp = require('mkdirp'),
    logger = require('./log.js'),
    yaml = require('js-yaml');

var log_colours = {
  silly: 'magenta',
  input: 'grey',
  verbose: 'cyan',
  prompt: 'grey',
  debug: 'blue',
  info: 'green',
  data: 'grey',
  help: 'cyan',
  warn: 'yellow',
  error: 'red'
};

// Function for loading the framework/plugin used to create the slideshow.
var SlideFramework = function(framework_path) {
  log.info('Looking for presentation framework in: ', framework_path);
  var fw = this;
  // Load the templates designed for the plugin.
  fw.templates = {};
  fs.readdir(path.join(framework_path, 'templates'), function(err, files){
    if(err){
      console.log(err);
    }
    files.forEach(function(f){
        console.log(f);
        fw.templates[f] = fs.readFileSync(f, 'utf8');
    });
  });



  //this.helpers = require(framework_path);
}

// A Framework can...
// Register helpers for use in the handlebars HTML template.
SlideFramework.registerHelpers = function() {
  var that = this;
  // register each helper
  Object.keys(that.helpers).forEach(function(key) {
    handlebars.registerHelper(key, that.helpers[key]);
  });
}



// Main function and execution of slidewinder.
var slidewinder = function(sessiondata) {

  // Load the slides, and select the ones desired.
  var allslides = load_collection(sessiondata.collection);
  sessiondata.slideset = pick_slides(allslides, sessiondata.slides);




  // Load the Plugin for the framework that will be used.
  var plugin = SlideFramework(sessiondata.framework);
  console.log(plugin);
  process.exit();


  // load the template
  var rel_path = '../templates/remark.html';
  var template_path = path.resolve(__dirname, rel_path);
  var template = fs.readFileSync(template_path, 'utf8');
  var renderer = handlebars.compile(template);

  // register the winder
  handlebars.registerHelper('slidewinder', function(all) {

    var bodies = all.data.root.slideset.map(function(x) {
      return x.body;
    });
    return bodies.join('\n---\n');

  });

  // render and save
  var deck = renderer(data);
  save_deck(deck, data);

}

// load a Markdown format slide collection
var load_collection = function(dirpath) {
  var collection = {};
  // load each slide, parse the frontmatter, and collect
  fs.readdirSync(dirpath).forEach(function(file) {
    var filepath = path.resolve(dirpath, file);
    var data = fs.readFileSync(filepath, 'utf8');
    var slide = fm(data);
    var name = slide.attributes.name;
    if (collection[name]) {
      log.error('Multiple slides have the name', name);
    } else {
      collection[name] = slide;
    }
  });
  log.info('Loaded', Object.keys(collection).length, 'markdown slide files from', dirpath);
  return collection;
}

// pick out slides from a collection
var pick_slides = function(collection, selections) {
  var picked = [];
  selections.forEach(function(selection) {
    var slide = collection[selection];
    if (slide) {
      picked.push(slide);
    } else {
      log.error('No slide found with name', name);
    }
  });
  log.info('Picked', picked.length, 'slides from collection');
  return picked;
}

// save a rendered slide deck
var save_deck = function(deck, data) {

  mkdirp(data.output);

  // write deck
  var deckpath = path.resolve(data.output, 'index.html');
  fs.writeFileSync(deckpath, deck);

  // write slidewinder data
  var datapath = path.resolve(data.output, 'deck.json');
  fs.writeFileSync(datapath, JSON.stringify(data, null, 2));

  var msg = 'deck (index.html) and data (deck.json) saved to';
  log.info(msg, data.output);

}

var log = logger();

module.exports = slidewinder;
