include("Functions.jl")
include("Algorithms.jl")
module MMA
  using Algorithms
  using Functions
export k_means, gram_schmidt, nearest_neighbor, avg, std,
       rms, angle, corrcoef, dist
end
