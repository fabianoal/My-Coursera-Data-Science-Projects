corr <- function(directory, threshold = 0){
  dfs <- do.call(rbind, lapply(list.files(path = directory, pattern = "*csv", full.names=TRUE), read.csv, stringsAsFactors = FALSE))
  vtRet <- as.data.frame(table(dfs[complete.cases(dfs), "ID"]))
  names(vtRet) <- c("id", "nobs")
  vtRet$id <- as.numeric(as.character(vtRet$id))
  vtRet <- vtRet[vtRet$nobs > threshold, ]
  sapply(vtRet$id, function(x) cor(dfs[dfs$ID == x, "sulfate"], y= dfs[dfs$ID == x, "nitrate"], use = "complete.obs"))
}

