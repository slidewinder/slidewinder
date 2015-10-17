var fs = require('fs')
  , path = require('path')
  , fm = require('front-matter')
  , handlebars = require('handlebars')
  , _ = require('lodash')
  , mkdirp = require('mkdirp')
  , logger = require('./log.js')
  , yaml = require('js-yaml');

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

var slidewinder = function(data) {

  // load the slides
  var collection = load_collection(data.collection);
  data.slideset = pick_slides(collection, data.slides);

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

// load a slide collection
var load_collection = function(dirpath) {

  var collection = [];

  // load each slide, parse the frontmatter, and collect
  fs.readdirSync(dirpath).forEach(function(file) {
    var filepath = path.resolve(dirpath, file);
    var data = fs.readFileSync(filepath, 'utf8');
    var slide = fm(data);
    slide.body = yaml.dump(slide.attributes) + '\n' + slide.body;
    collection.push(slide);
  });

  log.info('loaded', collection.length, 'slides from', dirpath);

  return collection;

}

// pick out slides from a collection
var pick_slides = function(collection, slidestr) {

  var slides = slidestr.split(',');
  var picked = _.filter(collection, function(x) {
    return _.contains(slides, x.attributes.name);
  });

  log.info('picked', picked.length, 'slides from collection');

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

  var msg = 'deck (index.html) and data (deck.json) saved to ';
  log.info(msg, data.output);

}

var log = logger();

module.exports = slidewinder;
