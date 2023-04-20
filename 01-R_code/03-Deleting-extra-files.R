# Made by Leandro Veloso
# main: Deleting the unorganized original raw

# 1: Removing uncompressed downloaded files ----
{ 
  # Closing connection
  closeAllConnections()
  
  # reading
  path_raw_uncompressed = file.path(path_project,  
                                "01-data", 
                                "04-output",
                                "01-data_temp",
                                "02-raw_uncompressed")
  
  pattern_str = "."
  list_file <- list.files(path_raw_uncompressed, pattern = pattern_str, full.names = FALSE)
  
  for (file in list_file) {  
    # Donwloading file and checking time
    file.remove(file.path(path_raw_uncompressed, file ))
  }
}

# 2: Removing compressed downloaded files ----
{ 
  # Closing connection
  closeAllConnections()
  
  # reading
  path_raw_uncompressed = file.path(path_project,  
                                    "01-data", 
                                    "04-output",
                                    "01-data_temp",
                                    "01-raw_compressed")
  
  pattern_str = "."
  list_file <- list.files(path_raw_uncompressed, pattern = pattern_str, full.names = FALSE)
  
  for (file in list_file) {  
    # Donwloading file and checking time
    file.remove(file.path(path_raw_uncompressed, file ))
  }
}
