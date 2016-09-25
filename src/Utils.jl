"""
File: Helpers.jl
Authors: Reese Pathak, Stephen Boyd

This file defines a set of Helper functions to be used across the
MMA function modules. The implementations take advantage of advanced
Julia features (short-hand functions, macros, expressions, symbols, etc.). If
you're interested in learning about the metaprogramming features available in
Julia, you're encouraged to read more about it at the link below:
http://docs.julialang.org/en/release-0.5/manual/metaprogramming/
"""

module Utils

export @mma_function, demean

demean(x) = x - avg(x)

macro mma_function(ex)
    # get argument vector
    argv = ex.args[1]
    # get x parameter expression (is not evaluated)
    x_param = argv.args[2]
    if length(argv.args) == 2 # single argument funtion, e.g., avg, rms, etc.
      Expr(:function, argv, quote
          @assert !isempty($x_param) "The vector you provided is empty!"
          $(ex.args[2])
      end) |> esc
    else # two-argument functions, e.g., corrcoef or angle
      y_param = argv.args[3]
      Expr(:function, argv, quote
          @assert !isempty($x_param) && !isempty($y_param) "A vector you provided is empty!"
          @assert length($x_param) == length($y_param) "The vector dimensions did not agree!"
          $(ex.args[2])
      end) |> esc
    end
end

end # end module
