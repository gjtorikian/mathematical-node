{Processor} = require('../build/Release/processor.node')
_ = require 'underscore'

FORMAT_TYPES = ["svg", "png", "mathml"]

DEFAULT_OPTS =
  ppi: 72.0
  zoom: 1.0
  base64: false
  maxsize: 0
  format: "svg"

module.exports = class Mathematical
  constructor: (opts = {}) ->
    @config = _.extend(DEFAULT_OPTS, opts)

    @processor = new Processor(@config)

  hello: ->
    @processor.hello
