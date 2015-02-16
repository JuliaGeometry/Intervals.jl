module Intervals

using Compat

export Interval

################################################################################
#
# Types, Constructors, and Accessors
#
################################################################################

abstract AbstractInterval{T}

immutable Interval{T} <: AbstractInterval{T}
    inf::T
    sup::T
end

Interval(i1,i2) = Interval(promote(i1,i2)...)

@inline inf(i::Interval) = i.inf
@inline sup(i::Interval) = i.sup

################################################################################
#
# Interval Arithmetic
#
################################################################################

@inline function (+)(i1::Interval, i2::Interval)
    Interval(i1.inf+i2.inf, i1.sup+i2.sup)
end

@inline function (-)(i1::Interval, i2::Interval)
    Interval(i1.inf-i2.inf, i1.sup-i2.sup)
end

@inline function (*)(i1::Interval, i2::Interval)
    a = i1.inf
    b = i1.sup
    c = i2.inf
    d = i2.sup
    ac = a*c
    ad = a*d
    bc = b*c
    bd = b*d
    Interval(min(min(min(ac,ad),bc),bd), max(max(max(ac,ad),bc),bd))
end

@inline function (/)(i1::Interval, i2::Interval)
    a = i1.inf
    b = i1.sup
    c = i2.inf
    d = i2.sup
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
    i1.inf == i2.inf && i1.sup == i2.sup
end

@inline function finishes(i1::Interval, i2::Interval)
    i1.sup == i2.sup && i1.inf > i2.inf
end

@inline function during(i1::Interval, i2::Interval)
    i1.inf > i2.inf && i1.sup <= i2.sup
end

@inline function starts(i1::Interval, i2::Interval)
    i1.inf == i2.inf && i1.sup < i2.sup
end

@inline function overlaps(i1::Interval, i2::Interval)
    i1.inf == i2.inf && i1.sup < i2.sup
end


end # module
