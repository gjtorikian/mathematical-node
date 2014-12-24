Mathematical = require('../lib/mathematical')
_ = require 'underscore'
glob = require 'glob'
path = require 'path'
fs = require 'fs'

describe "MathJax", ->
  MATHJAX_TEST_TEST_DIR = path.join('deps', 'mtex2MML', 'test', 'fixtures', 'MathJax')
  MATHJAX_TEST_TEX_DIR = path.join(MATHJAX_TEST_TEST_DIR, 'LaTeXToMathML-tex')

  mathematical = null

  beforeEach ->
    mathematical = new Mathematical

  it "works with all the MathJax files", ->
      glob "#{MATHJAX_TEST_TEX_DIR}/**/*.tex", (er, files) ->
        _.each files, (file) ->
          content = fs.readFileSync(file, "utf8")
          expect(-> mathematical.render(content)).not.toThrow()
