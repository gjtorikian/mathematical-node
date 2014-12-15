Mathematical = require('../lib/mathematical')
_ = require 'underscore'
_s = require 'underscore.string'
glob = require 'glob'
fs = require 'fs'

stripId = (blob) ->
  blob.replace(/id="surface.+?"/g, '')

convertContent = (eq) ->
  if eq.match /\$\$/
    type = "display"
  else
    type = "inline"

  short_svg_content = new Mathematical({"base64": true}).render(eq)

  if process.env.MATHEMATICAL_GENERATE_SAMPLE
    svg_content = new Mathematical({"base64": false}).render(eq)
    # remove \ and $, remove whitespace, keep alphanums, remove extraneous - and trailing -
    filename = eq.replace(/[\$\\]*/g, '').replace(/\s+/g, '-').replace(/[^a-zA-Z\d]/g, '-').replace(/-{2,}/g, '-').replace(/-$/g, '')
    fs.writeFileSync("samples/fixtures/#{filename}.svg", svg_content["svg"])

  "<img class=\"#{type}-math\" data-math-type=\"#{type}-math\" src=\"#{short_svg_content['svg']}\"/>"

describe "Mathematical", ->
  fixtures_dir = "spec/fixtures"
  mathematical = null

  fit "works with all the fixtures", ->
    glob "#{fixtures_dir}/before/*.text", (er, files) ->
      _.each files, (before) ->
        name = before.split('/').pop()

        source = fs.readFileSync(before, "utf8")
        actual = source.replace(/\$\$([\s\S]+?)\$\$/, convertContent)
        actual = actual.replace(/\$([\s\S]+?)\$/, convertContent)

        expected_file = before.replace(/before/, "after").replace(/text/, "html")
        expected = fs.readFileSync(expected_file, "utf8")

        expect(actual).toMatch("PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My")