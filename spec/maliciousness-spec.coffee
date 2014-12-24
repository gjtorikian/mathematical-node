Mathematical = require('../lib/mathematical')
_ = require 'underscore'
_s = require 'underscore.string'

describe "Maliciousness", ->

  it "does not error on unrecognized commands", ->
    mathematical = new Mathematical
    output = null
    # In mtex2MML, we raise a ParseError, but Mathematical suppresses it and returns the string.
    expect(-> output = mathematical.render('$not__thisisnotreal$')).not.toThrow()
    expect output, '$not__thisisnotreal$'

  it "does not blow up on bad arguments", ->
    # need to pass a hash here
    expect(-> new Mathematical("not a hash")).toThrow("options must be a hash!")

    # need to pass a string here
    expect(-> new Mathematical().render(123)).toThrow("text must be a string!")

  it "does not blow up on bad options", ->
    expect(-> new Mathematical({ppi: "not a number"})).toThrow("ppi must be an integer!")

    expect(-> new Mathematical({zoom: "not a number"})).toThrow("zoom must be an integer!")

    expect(-> new Mathematical({maxsize: "not a number"})).toThrow("maxsize must be an integer!")

    expect(-> new Mathematical({maxsize: -23})).toThrow("maxsize cannot be less than 0!")

    expect(-> new Mathematical({maxsize: 5.3})).toThrow("maxsize must be an integer!")

    expect(-> new Mathematical({format: 123})).toThrow("format must be a string!")

    expect(-> new Mathematical({format: "something amazing"})).toThrow("format type must be one of the following formats: svg, png, mathml")

    m = new Mathematical({maxsize: 2})
    expect(-> m.render('$a \ne b$')).toThrow("Size of latex string (8) is greater than the maxsize (2)")

    # signed long max
    m = new Mathematical({maxsize: 2147483647})
    expect(-> m.render('$a \ne b$')).not.toThrow()

    # unsigned long max
    m = new Mathematical({maxsize: 429496729555555555555429496729555555555555429496729555555555555})
    expect(-> m.render('$a \ne b$')).not.toThrow()
