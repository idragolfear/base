library(jsonlite)
library(digest)
library(readr)
hash_raw_data <- function(file_path, output_path = here::here("data", "raw", "provenance.json")) {
  
  if (!file.exists(file_path)){
    stop("Файл не знайдено: ", file_path)
  }

  file_contents <- readr::read_csv(file_path, show_col_types = FALSE)
  
  snapshot <- list(
    file       = basename(file_path),
    sha256     = digest::digest(file = file_path, algo = "sha256"),
    size_bytes = file.size(file_path),
    n_rows     = nrow(file_contents),
    n_cols     = ncol(file_contents),
    created_at = format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  )
  dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
  
  jsonlite::write_json(snapshot, output_path, pretty = TRUE, auto_unbox = TRUE)
  
  message("Знімок створено: ", output_path)
  invisible(snapshot)
}

verify_raw_data <- function(file_path, provenance_path = here::here("data", "raw", "provenance.json")) {
  
  if (!file.exists(provenance_path)) {
    stop("Файл походження не знайдено: ", provenance_path)
  }
  
  recorded <- jsonlite::read_json(provenance_path, simplifyVector = TRUE)
  current_hash <- digest::digest(file = file_path, algo = "sha256")
  
  if (current_hash == recorded$sha256) {
    message("ОК: файл не змінився з ", recorded$created_at)
    return(TRUE)
  } else {
    warning("УВАГА: хеш не співпадає! Файл міг бути змінений.")
    return(FALSE)
  }
}