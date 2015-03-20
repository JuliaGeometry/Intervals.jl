module Intervals

export Interval

export inf, sup

################################################################################
#
# Types, Constructors, and Accessors
#
################################################################################

abstract AbstractInterval{T}

immutable Interval{T} <: AbstractInterval{T}
    inf::T
    sup::T

    # Diagonal dispatch
    function Interval{T}(i::T, s::T)
        if i > s
            new(s, i)
        else
            new(i, s)
        end
    end
end

# try to promote types
function Interval(i,s)
    t = promote(i,s)
    Interval{typeof(t[1])}(t...)
end

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
    Interval(min(ac,ad,bc,bd), max(ac,ad,bc,bd))
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
    Interval(min(ac,ad,bc,bd), max(ac,ad,bc,bd))
end

for f in (:acos, :asin, :atan, :cos, :cosh, :exp, :log, :log10, :sin, :sinh,
          :sqrt, :tan, :tanh, :sind, :cosd, :tand, :sinpi, :cospi, :asind,
          :acosd, :atand, :sec, :csc, :cot, :secd, :cscd, :cotd, :asec, :acsc,
          :acot, :asecd, :acscd, :acotd, :sech, :csch, :coth, :asinh, :acosh,
          :atanh, :asech, :acsch, :acoth, :sinc, :cosc, :rad2deg, :log2, :log1p,
          :exp2, :exp10, :expm1, :abs, :abs2, :sign, :isqrt, :cbrt, :erf, :erfc,
          :erfcx, :erfi, :dawson, :erfinv, :erfcinv, :real, :imag, :conj, :cis,
          :factorial, :gamma, :lgamma, :lfact, :digamma, :trigamma, :airyai,
          :airyprime, :airyaiprime, :airybiprime, :besselj0, :besselj1,
          :bessely0, :bessely1, :eta, :zeta)
    @eval begin
        (Base.$f)(i::Interval) = Interval((Base.$f)(i.inf), (Base.$f)(i.sup))
    end
end

################################################################################
#
# Allen's Interval Algebra
#
################################################################################

@inline function (==)(i1::Interval, i2::Interval)
    i1.inf == i2.inf && i1.sup == i2.sup
end

@doc """
i1: _____

i2:           _____
""" ->
@inline function before(i1::Interval, i2::Interval)
    i1.sup < i2.inf # this is guaranteed because of the inner constructor
end

@doc """
i1: _____

i2:      _____
""" ->
@inline function meets(i1::Interval, i2::Interval)
    i1.sup == i2.inf && i1.inf < i2.inf
end

@doc """
i1:       _____

i2: ___________
""" ->
@inline function finishes(i1::Interval, i2::Interval)
    i1.sup == i2.sup && i1.inf > i2.inf
end

@doc """
i1:      _______

i2: ___________________
""" ->
@inline function during(i1::Interval, i2::Interval)
    i1.inf > i2.inf && i1.sup < i2.sup
end


@doc """
i1: ________

i2: _________________
"""->
@inline function starts(i1::Interval, i2::Interval)
    i1.inf == i2.inf && i1.sup < i2.sup
end

@doc """
i1: ________

i2:    ____________
""" ->
@inline function overlaps(i1::Interval, i2::Interval)
    i1.sup > i2.inf && i1.inf < i2.inf
end


end # module
