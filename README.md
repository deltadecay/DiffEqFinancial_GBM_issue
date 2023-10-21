# Error in Geometric Brownian Motion problem?

There may be an error in the implmentation of GeometricBrownianMotionProblem in DiffEqFinancial.jl


Tested With julia 1.9.3 and DiffEqFinancial v2.5.0.


The proposed fix included below:

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
After one year (T=1.0) the mean of the simulated price is 100.03, but the analytical expected value is approx 103.

