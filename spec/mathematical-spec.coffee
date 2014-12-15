Mathematical = require('../lib/mathematical')

describe "Mathematical", ->
  mathematical = null

  beforeEach ->
    mathematical = new Mathematical

  it "renders multiple calls", ->
    mathematical.render("$\\pi$")
    output = mathematical.render('$\\pi$')['svg']
    expect 1, output.match(/<svg/).size
