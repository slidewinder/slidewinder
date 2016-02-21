
# An importer extension for slidewinder imports stuff.
fs = require 'fs-extra'
frontmatter = require 'front-matter'
md = require('markdown').markdown


# Required elements for a slidewinder importer extension:

# A slidewinder importer extension needs a importer_name.
importer_name = 'markdown'

# A slidewinder importer extension needs a list of supported_extensions.
supported_extensions = ['.md']

# A slidewinder importer extension needs an import_type - either 'slide', or 'deck'.
import_type = 'slide'

# A slidewinder importer extension must have a read function.
# the read function must take a filepath, and must return
# everything nessecery for assignment to a slide or deck - depending on the type.
read = (filepath) ->
  data = fs.readFileSync(filepath, 'utf8')
  raw = frontmatter data
  raw.attributes.body = md.parse raw.body
  raw.attributes



### BOILERPLATE ###
# An import module must export and provide these things.
module.exports =
  importer_name: importer_name
  supported_extensions: supported_extensions
  import_type: import_type
  read: read
