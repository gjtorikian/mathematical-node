
FORMAT_TYPES = ["svg", "png", "mathml"]

DEFAULT_OPTS =
  ppi: 72.0
  zoom: 1.0
  base64: false
  maxsize: 0
  format: "svg"

class Mathematical
  constructor: (opts = {}) ->
    @name = name