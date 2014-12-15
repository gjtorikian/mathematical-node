{Processor} = require('../build/Release/processor.node')
_ = require 'underscore'
_s = require 'underscore.string'
Corrections = require './corrections'

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

    throw new TypeError "maxsize must be an integer!" unless _.isNumber(@config["maxsize"])
    throw new TypeError "maxsize cannot be less than 0!" if @config["maxsize"] < 0
    throw new TypeError "format must be a string!" unless _.isString(@config["format"])
    throw new TypeError "format type must be one of the following formats: #{FORMAT_TYPES.join(', ')}" unless _.contains(FORMAT_TYPES, @config["format"])

    config = _.clone(@config)
    config["format"] = _.indexOf(FORMAT_TYPES, @config["format"])

    @processor = new Processor config

  render: (maths) ->
    throw new TypeError "text must be a string!" unless _.isString(maths)
    maths = _s.strip(maths)
    throw new SyntaxError "text must be in itex format (`$...$` or `$$...$$`)!" unless _.isNull(maths.match(/\A\${1,2}/))

    maths = @apply_corrections(maths)

    try
      throw Error unless data_hash = @processor.process(maths)
      switch @config['format']
        when 'svg'
          data_hash["svg"] = data_hash["svg"][@xml_header.length..-1] # remove starting <?xml...> tag
          data_hash["svg"] = @svg_to_base64(data_hash["svg"]) if @config['base64']
          return data_hash
        when "png", "mathml"
          return data_hash
    catch e # an error in the C code, probably a bad TeX parse
      console.error "#{e.message}: #{maths}"

  apply_corrections: (maths) ->
    Corrections.apply(maths)

  xml_header: ->
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"

  svg_to_base64: (contents) ->
    "data:image/svg+xml;base64,#{new Buffer(contents).toString('base64')}"
