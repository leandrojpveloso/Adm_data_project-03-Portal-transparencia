# Made by Leandro Veloso
# main: renaming tender raw files, compress to gz, and allocate to raw folder

# 00: folder creation for tender ---- 
{
  # Path that contain the unzip files.
  path_raw_download = file.path(path_project,  
                                "01-data", 
                                "04-output",
                                "01-data_temp",
                                "02-raw_uncompressed")
  
  # Reading data
  dir_raw_data      = file.path(path_project, "01-data", "01-raw")
  
  # Biddings
  dir.create(file.path(dir_raw_data, "01-tender-purchases")     ,  showWarnings = FALSE)
  dir.create(file.path(dir_raw_data, "02-tender-items")         ,  showWarnings = FALSE)
  dir.create(file.path(dir_raw_data, "03-tender-participants")  ,  showWarnings = FALSE)
  dir.create(file.path(dir_raw_data, "04-tender-effort")        ,  showWarnings = FALSE)
}

# 01: Tender (bidding process) ---- 
{
  # Tender pattern file
  pattern_str = "._Licita."
  
  # Running over all files that contem _Licita
  list_file <- list.files(path_raw_download, pattern = pattern_str, full.names = FALSE)
  for (file in list_file) {
    
    # setting data
    #file = list_file[1]
    year <- substr(file, 1, 4)
    month <- substr(file, 5, 6)
    
    # Printing file
    print(paste(file, "; year:", year , "; month: ",month), quote = FALSE)
    
    # Set the input and output file paths
    input_file_path  <- file.path(file.path(path_raw_download,file))
    
    # output name
    export_filename = file.path(dir_raw_data, "01-tender-purchases",
                                paste0("tender_", year, "_", 
                                       month, ".csv.gz"))
    
    # Reading all content
    input_file <- file(input_file_path, "rt")
    file_contents <- readLines(input_file)
    close(input_file)
    
    # Write the contents to a gzipped output file
    output_file <- gzfile(export_filename, "wt")
    writeLines(file_contents, output_file)
    close(output_file)
  }
}  

# 02: item (lot) tender ---- 
{
  pattern_str = "._ItemLici."
  list_file <- list.files(path_raw_download, pattern = pattern_str, full.names = FALSE)
  for (file in list_file) {
    
    # setting data
    #file = list_file[1]
    year <- substr(file, 1, 4)
    month <- substr(file, 5, 6)
    
    # Printing file
    print(paste(file, "; year:", year , "; month: ",month), quote = FALSE)
    
    # Set the input and output file paths
    input_file_path  <- file.path(file.path(path_raw_download,file))
    
    # output name
    export_filename = file.path(dir_raw_data, "02-tender-items",
                                paste0("tender_item_", year, "_", 
                                       month, ".csv.gz"))
    
    # Reading all content
    input_file <- file(input_file_path, "rt")
    file_contents <- readLines(input_file)
    close(input_file)
    
    # Write the contents to a gzipped output file
    output_file <- gzfile(export_filename, "wt")
    writeLines(file_contents, output_file)
    close(output_file)
  }
}  

# 03: participants (bidders) data ---- 
{
  pattern_str = ".Participantes."
  list_file <- list.files(path_raw_download, pattern = pattern_str, full.names = FALSE)
  for (file in list_file) {
    
    # setting data
    #file = list_file[1]
    year <- substr(file, 1, 4)
    month <- substr(file, 5, 6)
    
    # Printing file
    print(paste(file, "; year:", year , "; month: ",month), quote = FALSE)
    
    # Set the input and output file paths
    input_file_path  <- file.path(file.path(path_raw_download,file))
    
    # output name
    export_filename = file.path(dir_raw_data, "03-tender-participants",
                                paste0("tender_item_participant", year, "_", 
                                       month, ".csv.gz"))
    
    # Reading all content
    input_file <- file(input_file_path, "rt")
    file_contents <- readLines(input_file)
    close(input_file)
    
    # Write the contents to a gzipped output file
    output_file <- gzfile(export_filename, "wt")
    writeLines(file_contents, output_file)
    close(output_file)
  }
}  

# 04: effort (empenho ralacionado) data ---- 
{
  pattern_str = "._EmpenhosRelacionados."
  list_file <- list.files(path_raw_download, pattern = pattern_str, full.names = FALSE)
  for (file in list_file) {
    
    # setting data
    #file = list_file[1]
    year <- substr(file, 1, 4)
    month <- substr(file, 5, 6)
    
    # Printing file
    print(paste(file, "; year:", year , "; month: ",month), quote = FALSE)
    
    # Set the input and output file paths
    input_file_path  <- file.path(file.path(path_raw_download,file))
    
    # output name
    export_filename = file.path(dir_raw_data, "04-tender-effort",
                                paste0("tender_effort_", year, "_", 
                                        month, ".csv.gz"))
    
    # Reading all content
    input_file <- file(input_file_path, "rt")
    file_contents <- readLines(input_file)
    close(input_file)
    
    # Write the contents to a gzipped output file
    output_file <- gzfile(export_filename, "wt")
    writeLines(file_contents, output_file)
    close(output_file)
  }
}  
