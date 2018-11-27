-- just an awkward way to find the location of the data files
return string.match(select(2, ...), ".*/")
