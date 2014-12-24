Mathematical = require('../lib/mathematical')
Helpers = require './helpers'
fs = require 'fs'

describe "Performance", ->

  it "handles big files", ->
    big_file = fs.readFileSync("#{Helpers.fixturesDir()}/performance/big_file.text", "utf8")

    start = new Date().getTime()
    actual = big_file.replace(/\$\$([\s\S]+?)\$\$/g, Helpers.convertContent)
    actual = actual.replace(/\$([\s\S]+?)\$/g, Helpers.convertContent)
    end = new Date().getTime()

    sec = (end - start) / 1000
    expect(sec).toBeLessThan(5)
