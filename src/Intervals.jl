module Intervals

using Compat

export Interval

################################################################################
#
# Types and Constructors
#
################################################################################

abstract AbstractInterval{T}

immutable Interval{T} <: AbstractInterval{T}
    lower::T
    upper::T
end

Interval(i1,i2) = Interval(promote(i1,i2)...)

################################################################################
#
# Interval Arithmetic
#
################################################################################

@inline function (+)(i1::Interval, i2::Interval)
    Interval(i1.lower+i2.lower, i1.upper+i2.upper)
end

@inline function (-)(i1::Interval, i2::Interval)
    Interval(i1.lower-i2.lower, i1.upper-i2.upper)
end

@inline function (*)(i1::Interval, i2::Interval)
    a = i1.lower
    b = i1.upper
    c = i2.lower
    d = i2.upper
    ac = a*c
    ad = a*d
    bc = b*c
    bd = b*d
    Interval(min(min(min(ac,ad),bc),bd), max(max(max(ac,ad),bc),bd))
end

@inline function (/)(i1::Interval, i2::Interval)
    a = i1.lower
    b = i1.upper
    c = i2.lower
    d = i2.upper
    ac = a/c
    ad = a/d
    bc = b/c
    bd = b/d
    Interval(min(min(min(ac,ad),bc),bd), max(max(max(ac,ad),bc),bd))
end

################################################################################
#
# Allen's Interval Algebra
#
################################################################################

@inline function (==)(i1::Interval, i2::Interval)
    i1.lower == i2.lower && i1.upper == i2.upper
end

@inline function finishes(i1::Interval, i2::Interval)
    i1.upper == i2.upper && i1.lower > i2.lower
end

@inline function during(i1::Interval, i2::Interval)
    i1.lower > i2.lower && i1.upper <= i2.upper
end

@inline function starts(i1::Interval, i2::Interval)
    i1.lower == i2.lower && i1.upper < i2.upper
end

@inline function overlaps(i1::Interval, i2::Interval)
    i1.lower == i2.lower && i1.upper < i2.upper
end


end # module
