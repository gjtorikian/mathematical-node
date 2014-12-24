Mathematical = require('../lib/mathematical')

describe "Corrections", ->
  mathematical = null

  beforeEach ->
    mathematical = new Mathematical

  it "adjusts lt gt", ->
    simple_lt = "$|q| < 1$"
    expect /|q| \\lt 1/, mathematical.apply_corrections(simple_lt)

    simple_gt = "$|q| > 1$"
    expect /|q| \\gt 1/, mathematical.apply_corrections(simple_gt)
