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

  render: (maths) ->
    data_hash = @processor.process(maths)
    switch @config['format']
      when 'svg'
        data_hash["svg"] = data_hash["svg"][@xml_header.length..-1] # remove starting <?xml...> tag
        data_hash["svg"] = @svg_to_base64(data_hash["svg"]) if @config['base64']
        data_hash

    data_hash

  xml_header: ->
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"

  svg_to_base64: (contents) ->
    #"data:image/svg+xml;base64,#{Base64.strict_encode64(contents)}"
    return contents
