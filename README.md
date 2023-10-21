# Error in Geometric Brownian Motion problem?

I think the implementation of GeometricBrownianMotionProblem is incorrect. It should be as below:

```
doc doc"""

``dx = μ x dt + σ x dW_t``

"""
function GeometricBrownianMotionProblem(μ, σ, u0, tspan; kwargs...)
    f = function (u, p, t)
        μ * u
    end
    g = function (u, p, t)
        σ * u
    end
    SDEProblem{false}(f, g, u0, tspan; kwargs...)
end

```

The analytical expected value of a GBM is (for any t):
```
E[x_t] = u0 * exp(μ * t)
```

Included in file issue.jl is a demo which simulates a stock price process with risk free rate 3% and starting value 100.
After one year (T=1.0) it should be close to 103, but it is 100.03.
