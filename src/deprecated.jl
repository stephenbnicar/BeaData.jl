import Base: @deprecate

@deprecate Bea(key) = Bea(API_URL, key)

function Bea()
    Base.depwarn("`Bea` struct is deprectaed.", :Bea)
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

    return Bea(key)
end
