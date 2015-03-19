using Intervals
using Base.Test

@test Interval(1,1) == Interval(1.0, 1.0)
@test Interval{Float64}(1,1) === Interval{Float64}(1.0, 1.0)
