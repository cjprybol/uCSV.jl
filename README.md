# uCSV.jl

[![Build Status](https://travis-ci.org/cjprybol/uCSV.jl.svg?branch=master)](https://travis-ci.org/cjprybol/uCSV.jl)

[![Coverage Status](https://coveralls.io/repos/cjprybol/uCSV.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/cjprybol/uCSV.jl?branch=master)

[![codecov.io](http://codecov.io/github/cjprybol/uCSV.jl/coverage.svg?branch=master)](http://codecov.io/github/cjprybol/uCSV.jl?branch=master)

uCSV.jl implements 2 main functions, `uCSV.read()` and `uCSV.write()`

# put docstrings here

By default, the read function assumes that you have a table of header-less data seperated by commas. It will only try to detect the variable types from the first row of parsed data, and will only attempt to detect whether the parsed entry is an Int, a Float64, or whether to leave it as a String. No detection of quotes, escapes, nulls, booleans, dates, times, datetimes, comments, malformed data, or any other common features of CSV parsers will occur unless requested by the users. However, the user can request any of these parsing configurations using a concise and flexible API, and uCSV.read aims to be able to process any delimited data encoded in UTF-8 (to handle other encodings, see StringEncodings).

uCSV.write is similarly simple, and will only output the data as comma seperated strings. Quotes can be requested by the user.

Parsing CheatSheet

Package size compared to others

Read speed compared to others

Testing on #n real-world datasets hand-selected for their unique formatting, with an emphasis on ugly ones.

# i have a header

# i have nulls

# i have booleans

# i have symbols

# i have dates

# i have datetimes

# i would like a custom parser

# i have quotes

# i have quoted fields with internal double quotes

# i have comments

# i have malformed lines

# i want to read a file from a URL

# i have data that isn't in UTF-8

# i have a compressed (e.g. gzip, bzip2) file
