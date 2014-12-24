Mathematical = require('../lib/mathematical')

describe "Corrections", ->
  mathematical = null

  beforeEach ->
    mathematical = new Mathematical

  it "adjusts lt gt", ->
    simple_lt = "$|q| < 1$"
    expect(mathematical.applyCorrections(simple_lt)).toMatch(/|q| \\lt 1/)

    simple_gt = "$|q| > 1$"
    expect(mathematical.applyCorrections(simple_gt)).toMatch(/|q| \\gt 1/)
