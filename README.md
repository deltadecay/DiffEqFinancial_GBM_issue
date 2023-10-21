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

I've included a demo which simulates a stock price process with risk free rate 3% and starting value 100.
After one year (T=1.0) it should be close to 103, but it is 100.03.
```
using DifferentialEquations
using DiffEqFinancial
using Statistics


@doc doc"""

``dx = μ x dt + σ x dW_t``

"""
function MyGeometricBrownianMotionProblem(μ, σ, u0, tspan; kwargs...)
    f = function (u, p, t)
        μ * u
    end
    g = function (u, p, t)
        σ * u
    end
    SDEProblem{false}(f, g, u0, tspan; kwargs...)
end

r = 0.03
sigma = 0.2
S0 = 100
t=0
T=1.0
days = 252
dt = 1/days

prob = GeometricBrownianMotionProblem(r, sigma, S0, (t,T))
#prob = MyGeometricBrownianMotionProblem(r, sigma, S0, (t,T))
sol = solve(prob;dt=dt)
monte_prob = EnsembleProblem(prob)
sol = solve(monte_prob, EM(); dt=dt,trajectories=100000)
us=[sol[i].u for i in eachindex(sol)]
simulated = mean(us)

tsteps = collect(0:dt:T)
# Expected value of GBM
expected = S0 * exp.(r * tsteps)

# Error
error = sum(abs2.(simulated .- expected))

```