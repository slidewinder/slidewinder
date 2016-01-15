winston = require 'winston'

levels =
  silly: 0
  input: 1
  verbose: 2
  prompt: 3
  debug: 4
  data: 5
  info: 6
  help: 7
  warn: 8
  error: 9

colours =
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

# The logger with pretty colours
logger = () ->
  log = new (winston.Logger)({
      transports: [new winston.transports.Console({
          level: 'info'
          levels: levels
          colorize: true
      })]
      level: 'info'
      levels: levels
      colorize: true
  })
  winston.addColors colours
  log

# Fake logger that we use to suppress messages
# during tests
test_logger = () ->
  log =
    silly: (a...) -> null
    input: (a...) -> null
    verbose: (a...) -> null
    prompt: (a...) -> null
    debug: (a...) -> null
    data: (a...) -> null
    info: (a...) -> null
    help: (a...) -> null
    warn: (a...) -> null
    error: (a...) -> null
  log

if process.env.NODE_ENV == 'test'
  module.exports = test_logger
else
  module.exports = logger
