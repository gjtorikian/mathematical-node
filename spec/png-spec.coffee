Mathematical = require('../lib/mathematical')
fs = require 'fs'

describe "Mathematical", ->
  mathematical = null
  fixtures_dir = "spec/fixtures"

  beforeEach ->
    fs.unlinkSync("#{fixtures_dir}/png/pmatrix.png") if fs.existsSync("#{fixtures_dir}/png/pmatrix.png")

  it "creates a png", ->
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
    mathematical = new Mathematical(format: "png")
    data_hash = mathematical.render(string)

    # check png header
    fs.writeFileSync("#{fixtures_dir}/png/pmatrix.png", data_hash["png"], 'binary')
    fd = fs.openSync("#{fixtures_dir}/png/pmatrix.png", 'r')
    buffer = new Buffer(16)
    header = fs.readSync(fd, buffer, 0, 16, 0)
    expect buffer.toString('hex'), "89504e470d0a1a0a00"
