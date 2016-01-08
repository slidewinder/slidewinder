#!/usr/bin/env node
;
var program, sw;

program = require('commander');

sw = require('../lib/slidewinder_lib.js');

program.option('-i, --input <file>', 'Specification file to use to compile slideshow').option('-o, --output <file>', 'Folder to save slideshow to').parse(process.argv);

if (program.input && program.output) {
  program.specification = sw.yamlToSpec(program.input);
  sw.compile(program.specification, program.output);
  process.exit();
} else {
  program.help();
}
