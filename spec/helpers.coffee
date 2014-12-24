Mathematical = require('../lib/mathematical')

module.exports = Helpers =
  convertContent: (eq) ->
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


  fixturesDir: ->
    "spec/fixtures"