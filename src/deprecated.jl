import Base: @deprecate

mutable struct Bea
    url::AbstractString
    key::AbstractString
end

function Bea()
    Base.depwarn("The `Bea` struct is deprected; " *
        "`key` is now autoloaded on package startup " *
        "or use `USER_ID = key`.", :Bea)
    key = ""
    if "BEA_KEY" in keys(ENV)
        key = ENV["BEA_KEY"]
    elseif isfile(joinpath(homedir(), ".beadatarc"))
        open(joinpath(homedir(),".beadatarc"), "r") do f
            key = read(f, String)
        end
        key = rstrip(key)
    else
        error("No API key found, connection not initialized")
    end
    println("API key loaded.")

    return Bea(API_URL, key)
end

@deprecate Bea(key) USER_ID = key
