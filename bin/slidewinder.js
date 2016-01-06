#!/usr/bin/env node
;
var path, pjson, program, yaml;

pjson = require('../package.json');

path = require('path');

program = require('commander');

yaml = require('js-yaml');

program.version(pjson.version).command('compile', 'compile a presentation from a specification file').parse(process.argv);
