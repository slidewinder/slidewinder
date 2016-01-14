fs = require 'fs-extra'
path = require 'path'

runtestdir = (dir) ->
  fs.readdirSync(dir).forEach (file) ->
    require(path.join(dir, file))

describe "lib ->", ->
  runtestdir path.join(__dirname, 'lib')

# describe("bin", () ->
#   runtestdir ('./bin')
#
# describe("extensions", () ->
#     runtestdir ('./extensions')
