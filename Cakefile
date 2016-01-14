fs = require 'fs'
{spawn} = require 'child_process'

buildlib = (callback) ->
  coffee = spawn 'coffee', ['-c', '-o', 'lib/', 'src/lib/']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    console.log data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

buildbin = (callback) ->
  coffee = spawn 'coffee', ['-c', '-b', '--no-header', '-o', 'bin/', 'src/bin/']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    console.log data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

buildext = (callback) ->
  coffee = spawn 'coffee', ['-c', '-o', 'extensions/', 'src/extensions/']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    console.log data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

task 'build', 'Build lib JS files from src directory', ->
    buildlib()
    buildbin()
    buildext()
