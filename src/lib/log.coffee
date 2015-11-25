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


# Create a pretty logger
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

module.exports = logger
