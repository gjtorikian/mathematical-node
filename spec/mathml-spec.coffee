Mathematical = require('../lib/mathematical')

describe "MathML", ->
  mathematical = null

  it "returns mathml", ->
    string = """
    $$
\\begin{pmatrix}
     1 & a_1 & a_1^2 & \\cdots & a_1^n \\\\
     1 & a_2 & a_2^2 & \\cdots & a_2^n \\\\
     \\vdots  & \\vdots& \\vdots & \\ddots & \\vdots \\\\
     1 & a_m & a_m^2 & \\cdots & a_m^n
     \\end{pmatrix}
$$
"""

    mathematical = new Mathematical(format: "mathml")
    mathml = mathematical.render(string)["mathml"]
    expect(mathml).toMatch("<math xmlns='http:\/\/www.w3.org\/1998\/Math\/MathML' display='block'><semantics><mrow><mrow><mo>")
