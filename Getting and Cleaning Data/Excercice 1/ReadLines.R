if (!file.exists("./data")){
  dir.create("./data")
}

web_page <- readLines("http://biostat.jhsph.edu/~jleek/contact.html")
web_page
web_page[[1]]
nchar(web_page[[10]])
nchar(web_page[[20]])
nchar(web_page[[30]])
nchar(web_page[[100]])
