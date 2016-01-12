fs = require 'fs'
{spawn} = require 'child_process'
log = console.log

buildlib = (callback) ->
  log "Compiling coffeescript JS"
  coffee = spawn 'coffee', ['-c', '-o', 'lib/', 'src/lib/']

  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString

  coffee.stdout.on 'data', (data) ->
    log data.toString

  coffee.on 'exit', (code) ->
    callback?() if code is 0


buildbin = (callback) ->
  log "Creating JS binaries in ./bin"
  coffee = spawn 'coffee', ['-c', '-b', '--no-header', '-o', 'bin/', 'src/bin/']

  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString

  coffee.stdout.on 'data', (data) ->
    log data.toString

  coffee.on 'exit', (code) ->
    callback?() if code is 0


makebinexecutable = (callback) ->
  log "Making binaries executable"
  fs.chmodSync('bin/slidewinder.js', '0755')
  callback?()


task 'build', 'Build lib JS files from src directory', ->
  buildlib()
  buildbin()
  makebinexecutable()
  log "Done :)"
