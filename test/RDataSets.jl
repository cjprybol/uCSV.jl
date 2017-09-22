using CSV, HTTP, CodecZlib

html = "https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/SP500.csv.gz"

CSV.read(GzipDecompressionStream(HTTP.body(HTTP.get(html))))

for line in eachline((IOBuffer(Requests.read(get(html)))))
    println(line)
end

https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/COUNT/loomis.csv.gz #NA's with bools
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/COUNT/titanic.csv.gz #categorical int
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/Clothing.csv.gz # quoted headers
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/Garch.csv.gz # encode and transform days of week
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/Grunfeld.csv.gz # parse year
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/Icecream.csv.gz # F -> C transform
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/MCAS.csv.gz # diverse data types
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/RetSchool.csv.gz # NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/TranspEq.csv.gz # encode states as two letters
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/incomeInequality.csv.gz # like it
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/aspirin.csv.gz # ugly bibtex citations
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/birthdeathrates.csv.gz # recode countries
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/heptathlon.csv.gz # transform countries, names
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/meteo.csv.gz # year range
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/pottery.csv.gz # recode column names, transform to Kevlin
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/rearrests.csv.gz # convert to Freq Table
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/smoking.csv.gz # encode ugly bibtex
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/voting.csv.gz # split into republican and democrat
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HistData/Jevons.csv.gz # multiple error encodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HistData/Minard.temp.csv.gz # strange date parsing
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HistData/Snow.pumps.csv.gz # missing values
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HistData/Wheat.monarchs.csv.gz # dates and roman numerals
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/KMsurv/baboon.csv.gz # more dates
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/KMsurv/bcdeter.csv.gz # NA's after row detect
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/KMsurv/kidtran.csv.gz # boolean encodings and age groupings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/KMsurv/pneumon.csv.gz # lots of fun encodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/Boston.csv.gz
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/beav1.csv.gz # day time conversions
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/beav2.csv.gz # day time conversions
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/caith.csv.gz # freqtable fun
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/cpus.csv.gz # cpu names and convert memory
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/mammals.csv.gz # animal name conversions
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/newcomb.csv.gz # int parsing
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/npr1.csv.gz # make sure column one doesn't parse as int
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/road.csv.gz # state encodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/waders.csv.gz # read letter as char
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Zelig/SupremeCourt.csv.gz # nullable bit array
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Zelig/approval.csv.gz # month year
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Zelig/immigration.csv.gz # lots of NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/adehabitatLT/albatross.csv.gz # fun dates and 0 in R2n followed by floats !!maybe drop!!
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/adehabitatLT/bear.csv.gz # same as above but even better
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/adehabitatLT/buffalo.csv.gz # again
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/adehabitatLT/whale.csv.gz # ugly again
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/boot/acme.csv.gz # month parse
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/boot/coal.csv.gz # what kind of date is this?
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/boot/neuro.csv.gz # lots of NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/car/Anscombe.csv.gz # state conversions
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/car/Depredations.csv.gz # convert lat long into something else
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/car/Florida.csv.gz # counties to lowercase & dots to spaces
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/car/Freedman.csv.gz # dots to spaces
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/cluster/animals.csv.gz
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/cluster/votes.repub.csv.gz # headers to dates
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/datasets/HairEyeColor.csv.gz # categorical recode
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/datasets/Titanic.csv.gz # categorical recode
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/datasets/UCBAdmissions.csv.gz # categorical recode
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/datasets/USJudgeRatings.csv.gz # judge name processing
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/datasets/VADeaths.csv.gz # age range
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/datasets/mtcars.csv.gz # have to
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/datasets/randu.csv.gz # exponential parsing of numerics
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/gap/PD.csv.gz # so ugly
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/gap/lukas.csv.gz # MF sex recoding
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/gap/mao.csv.gz # Int and Int/Int
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/plyr/baseball.csv.gz # lots of NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/pscl/ca2006.csv.gz # true false encodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/pscl/presidentialElections.csv.gz # different true false
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/psych/Reise.csv.gz # make headers and first column the same
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/psych/Schmid.csv.gz # another freqtable
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/psych/Thurstone.csv.gz # another freqtable with recodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/psych/bfi.csv.gz # late NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/psych/neo.csv.gz # freqtable recodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/robustbase/Animals2.csv.gz # unsure
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/robustbase/ambientNOxCH.csv.gz # scattered NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/robustbase/condroz.csv.gz # fun pH conversion
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/robustbase/education.csv.gz # state recodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/sem/Tests.csv.gz # late NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/survival/lung.csv.gz # 1-2 status and late NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/vcd/Bundesliga.csv.gz # year column & date column!
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/vcd/Employment.csv.gz # employment length
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/vcd/PreSex.csv.gz # lots of encodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/vcd/RepVict.csv.gz # FreqTable

https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/ggplot2/economics.csv.gz # more dates
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/ggplot2/presidential.csv.gz # more dates
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/pscl/UKHouseOfCommons.csv.gz
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/vcd/Lifeboats.csv.gz # dates

https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/vcd/SexualFun.csv.gz
