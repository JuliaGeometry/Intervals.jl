using Intervals
using Base.Test

@test Interval(1,1) == Interval(1.0, 1.0)
@test Interval{Float64}(1,1) === Interval{Float64}(1.0, 1.0)

@test Interval(1,1)/Interval(1,1) == Interval(1,1)
@test Interval(1,1)/Interval(2,3) == Interval(1/3,0.5)

@test Interval(1,1)*Interval(1,1) == Interval(1,1)
@test Interval(1,1)*Interval(2.5,3.4) == Interval(3.4,2.5)

@test inf(Interval(2,1)) == 1
@test sup(Interval(2,1)) == 2
