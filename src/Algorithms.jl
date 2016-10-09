include("Utils.jl")
include("Kmeans.jl")
module Algorithms
  using Utils
  using K_means
export nearest_neighbor, gram_schmidt, k_means

function gram_schmidt(vector_list)
  epsilon = 1e-6
  k = length(vector_list)
  qs = []
  for vector in vector_list
    q_i = vector
    # orthogonalization with previous vectors
    for j = 1:length(qs)
      q_i -= (qs[j]'vector).*qs[j]
    end
    # check for dependence, quit if q_i ~= 0
    if norm(q_i) <= epsilon
      break
    end
    # normalize and store the result
    q_i = q_i/norm(q_i)
    push!(qs,q_i)
  end
  return qs
end

function nearest_neighbor(query, vector_list)
  """
  args:
    query: vector query
    vector_list: list of vectors

  prints the index of the closest vector, the vector itself, and
  the distance to the minimum vector

  returns: the closest vector to the query
  """
  min_dist, min_vector, min_index = Inf, nothing, nothing
  for (index, vector) in enumerate(vector_list)
    dist_to_vector = dist(query, vector)
    if dist_to_vector < min_dist
      min_dist = dist_to_vector
      min_vector = vector
      min_index = index
    end
  end
  println("Index: $(min_index) \t Vector: $(min_vector) \t Distance: $(min_dist)")
  return min_vector
end
end
