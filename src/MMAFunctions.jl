include("Helpers.jl")
"""
File: MMAFunctions.jl
Authors: Reese Pathak, Stephen Boyd

This file defines a set of scalar-valued functions that take one or two vectors
as input and output a scalar as output. We support average, standard deviation,
root mean square, angle, distance, and correlation coefficient.
"""
module MMAFunctions
using Helpers
export avg, std, rms, angle, corrcoef, dist


# FUNCTION DEFINITIONS.

# Average
@mma_function avg(x) = mean(x)

# RMS value
@mma_function rms(x) = norm(x)/sqrt(length(x))

# Distance
@mma_function dist(x, y) = norm(x - y)

# Standard deviation
@mma_function std(x) = norm(demean(x))/sqrt(length(x))

# Angle
@mma_function angle(x, y) = acos(dot(x,y)/(norm(x)*norm(y)))

# Correlation coefficient
@mma_function corrcoef(x, y) = cos(angle(demean(x), demean(y)))

end
