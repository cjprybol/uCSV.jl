__precompile__(true)
module uCSV

COLMAP{T} = Union{Dict{String, T}, Dict{Int, T}}

include("read.jl")
include("write.jl")
include("parsesource.jl")
include("parsefields.jl")
include("checkfield.jl")
include("helperfunctions.jl")

end # module
