complete <- function(directory, id = 1:332) {
  dfs <- do.call(rbind, lapply(file.path(paste0(directory,.Platform$file.sep,(sprintf('%03d', id)), '.csv')), read.csv))
  vtRet <- as.data.frame(table(dfs[complete.cases(dfs), "ID"]))
  names(vtRet) <- c("id", "nobs")
  vtRet
}