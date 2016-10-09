"""
File: Kmeans.jl
Authors: Reese Pathak, Stephen Boyd

K-means implementation in Julia

Parameters:
   list_of_vectors - The vectors to cluster, represented as an array of N n-vectors
                     (N column vectors of length n).
   k               - The number of clusters (defaults to 2)

Returns:
   representatives - The cluster representatives represented as an array of k
                     column vectors of length n.
   labels          - An array of N cluster assignments in the same order as data,
                     so that the 1st data point's cluster assignment is labels[i].
                     The labels themselves index into the representatives list,
                     i.e. representatives[labels[1]] returns the first data
                     point's representative.
   losses          - An array containing the value of J at each iteration.
"""

module K_means

export k_means

function k_means(list_of_vectors; k=2, epsilon=1e-6)
  losses = Float64[] # array of losses
  # initialize representatives and assignments
  representatives, assignments = initialize_representatives(list_of_vectors, k)
  while has_not_converged(losses, epsilon)
    assignments = partition_data(list_of_vectors, representatives)
    representatives = update_representatives(list_of_vectors, assignments,
                                              k, representatives)
    push!(losses, loss(list_of_vectors, representatives, assignments))
   end
  return representatives, labels, losses
end

function has_not_converged(losses, epsilon)
  return (length(losses) >= 2 && abs(losses[end] - losses[end-1]) <= epsilon)
end
# Assigns each data point to the closest representative
function partition_data(data, representatives)
  labels = Int[]
  for i in 1:length(data)
    # calculate the euclidean distance from the ith data point to each representative
    representative_distances = pairwise_distance(data[i], representatives)
    # find the representative closest to the ith data point (argmin)
    distance, representative_index = findmin(representative_distances)
    push!(labels, representative_index)
  end
  return labels
end

# Calculates each representative as the mean of it's data points
function update_representatives(data, labels, k, old_representatives)
  representatives = Vector[]
  for i = 1:k
    # get the data points assigned to the representative
    representative_pts = data[labels .== i]
    # if the representative has assigned data points, set it to be their mean
    if length(representative_pts) > 0
      push!(representatives, mean(representative_pts))
    else # otherwise, leave it alone
      push!(representatives, old_representatives[i])
    end
  end
  return representatives
end

# Calculates the loss (J) of the given clustering.
function loss(data, representatives, labels)
  N = length(data)
  J = 0.0
  for i = 1:N
    J += norm(data[i] - representatives[labels[i]])^2
  end
  return J*(1/N)
end

function initialize_representatives(data, k)
  N = length(data)
  n = length(data[1])
  labels = rand(1:k,N)
  representatives = update_representatives(data, labels, k, [zeros(n) for i=1:k])
  return representatives, labels
end

# Calculates the Eudclidean distance between vector and each vectors in 'vectors',
# returning an array.
function pairwise_distance(vector, list_of_vectors)
  return Float64[norm(vector - list_of_vectors[i])
                  for i=1:length(list_of_vectors)]
end

end
