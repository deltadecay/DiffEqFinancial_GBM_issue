using DifferentialEquations
using DiffEqFinancial
using Statistics

include("solution.jl")

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

# Simulated price paths
us=[sol[i].u for i in eachindex(sol)]

# Mean of all paths at all time steps
simulated = mean(us)

tsteps = collect(0:dt:T)
# Expected value of GBM at every simulated time step 
expected = S0 * exp.(r * tsteps)

println("Stock price at T=1.0:")
println("Simulated = ", simulated[end])
println("Expected = ", expected[end])
# Error
#error = sum(abs2.(simulated .- expected))



