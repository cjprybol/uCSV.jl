using Documenter, uCSV

makedocs(
    root = Pkg.dir("uCSV", "docs"),
    source = "src",
    build = "build",
    doctest = true,
    modules = [uCSV],
    format   = :html,
    sitename = "uCSV.jl",
    checkdocs = :all,
    debug = true,
    pages = Any["Home" => "index.md",
                "Manual" => Any["man/defaults.md",
                                "man/headers.md",
                                "man/dataframes.md",
                                "man/delimiters.md",
                                "man/missingdata.md",
                                "man/declaring-column-element-types.md",
                                "man/declaring-column-vector-types.md",
                                "man/international.md",
                                "man/customparsers.md",
                                "man/quotes-escapes.md",
                                "man/comments-skiplines.md",
                                "man/malformed.md",
                                "man/url.md",
                                "man/compressed.md",
                                "man/categoricals.md",
                                "man/unsupported.md",
                                "man/benchmarks.md"]])

deploydocs(
    repo = "github.com/cjprybol/uCSV.jl.git",
    julia = "0.6",
    target = "build",
    deps = nothing,
    make = nothing)
