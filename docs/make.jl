using Documenter, uCSV

makedocs(
    modules = [uCSV],
    format   = :html,
    clean = false,
    doctest = true,
    sitename = "uCSV.jl",
    pages = Any["Home" => "index.md",
                "Manual" => Any["man/defaults.md",
                                "man/headers.md",
                                "man/delimiters.md",
                                "man/dataframes.md",
                                "man/missingdata.md",
                                "man/declaring-types.md",
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
    julia = "0.6")
