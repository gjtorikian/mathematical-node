Mathematical = require('../lib/mathematical')

describe "Mathematical", ->
  it "loads", ->
    m = new Mathematical
    expect 'hello world', m.hello('world')
