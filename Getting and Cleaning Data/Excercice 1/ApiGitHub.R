library(httr)

oauth_endpoints("github")

mApp <- oauth_app("github", key="07fff7616cd7a6e1615a", secret="d17a1b75fae05caeda4c07ec7c1165b3ac52550d")

github_token <- oauth2.0_token(oauth_endpoints("github"), mApp)
#github_token = sign_oauth1.0(mApp,token="token_teste", token_secret="91b8ce789a3c29244770366f7264ee155b31e08c")

#github_token = oauth_signature(url = "https://api.github.com/users/jtleek/repos", method = "GET", mApp, token = "token_teste", token_secret = "91b8ce789a3c29244770366f7264ee155b31e08c")

gtoken <- config(token = github_token)

req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

stop_for_status(req)
content(req)

jeffsRepo <- content(req)

Filter (function(obj) obj$name == "datasharing", jeffsRepo)[[1]]$name
names(Filter (function(obj) obj$name == "datasharing", jeffsRepo)[[1]])
Filter (function(obj) obj$name == "datasharing", jeffsRepo)[[1]]$name
Filter (function(obj) obj$name == "datasharing", jeffsRepo)[[1]]$created_at
