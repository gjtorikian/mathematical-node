module.exports = class Corrections
  @apply: (maths) ->
    # from the itex website:
    # It is possible (though probably not recommended) to insert MathML markup
    # inside itex equations. So "<" and ">" are significant.
    # To obtain a less-than or greater-than sign, you should use \lt or \gt, respectively.
    maths.replace(/</g, '\\lt').replace(/>/g, '\\gt')
