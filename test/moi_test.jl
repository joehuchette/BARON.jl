module MOITests

using BARON
using Test

using MathOptInterface
const MOI = MathOptInterface
const MOIT = MOI.Test
const MOIU = MOI.Utilities
const MOIB = MOI.Bridges

const optimizer = MOIU.CachingOptimizer(BARON.Model{Float64}(), BARON.Optimizer());

# TODO: test infeasibility certificates, duals.
const config = MOIT.TestConfig(atol=1e-5, rtol=1e-4, infeas_certificates=false, duals=false)

@testset "MOI Continuous Linear" begin
    excluded = [
        "linear7", # vector constraints
        "linear8b", # certificate provided in this case (result count is 1)
        "linear8c", # should be unbounded below, returns "Preprocessing found feasible solution with value -.200000000000E+052"
        "linear15", # vector constraints
        "partial_start" # TODO
    ]
    # MOIT.partial_start_test(optimizer, config)
    MOIT.contlineartest(optimizer, config, excluded)
    # MOIT.linear8btest(optimizer, MOIT.TestConfig(atol=1e-5, rtol=1e-4, infeas_certificates=true, duals=false))
end

@testset "MOI Integer Linear" begin
    excluded = [
        "int2" # SOS1
    ]
    MOIT.intlineartest(optimizer, config, excluded)
end

# @testset "MOI Nonlinear" begin
#     MOIT.nonlineartest(optimizer, config)
# end

end # module
