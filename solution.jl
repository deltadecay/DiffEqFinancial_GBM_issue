
#=
@doc doc"""

``dx = μ x dt + σ x dW_t``

"""
=#
function MyGeometricBrownianMotionProblem(μ, σ, u0, tspan; kwargs...)
    f = function (u, p, t)
        μ * u
    end
    g = function (u, p, t)
        σ * u
    end
    SDEProblem{false}(f, g, u0, tspan; kwargs...)
end


