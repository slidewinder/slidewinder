
# An importer extension for slidewinder imports stuff. 
fs = require 'fs-extra'
frontmatter = require 'front-matter'
md = require('markdown').markdown


# Required elements for a slidewinder importer extension:

# A slidewinder importer extension needs a name.
module.exports.name = 'markdown'

# A slidewinder importer extension needs a list of supported file extensions.
module.exports.file_extensions = ['.md']

# A slidewinder importer extension needs a type - either 'slide', or 'deck'.
module.exports.type = 'slide'

# A slidewinder importer extension must have a read function.
# the read function must take a filepath, and must return
# everything nessecery for assignment to a slide or deck - depending on the type.
module.exports.read = (filepath) ->
  data = fs.readFileSync(filepath, 'utf8')
  raw = frontmatter data
  raw.attributes.body = md.parse raw.body
  raw.attributes



