pollutantmean <- function(directory, pollutant, id = 1:332) {
  dfs <- do.call(rbind, lapply(file.path(paste0(directory,.Platform$file.sep,(sprintf('%03d', id)), '.csv')), read.csv))
  mean(dfs[,pollutant], na.rm = TRUE)
}
