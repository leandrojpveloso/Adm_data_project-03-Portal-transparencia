# Title: Speed study
# main: finding the fast way to import compras.dados.gov

# 1: Downloading data ----
{
  # folder to save compress files
  path_zip_raw <- file.path(path_project, 
                            "01-data", 
                            "04-output",
                            "01-data_temp",
                            "01-raw_compressed")  
  
  # Loop using sequence of month/year defined in the master file
  time_sum<-rep(NA,length(sequence_dates))
  for (k in seq_along(sequence_dates)) {
      # Getting year month
      year  <- year(sequence_dates[k])
      
      # month leading zero 
      month <- str_pad(month(sequence_dates[k]), 2, pad = "0")
      
      # Pasting and printing 
      file = paste0(year,month)
      print(file)
      
      # Downloading tender dataset
      URL_bid  = paste0("https://www.portaltransparencia.gov.br/download-de-dados/licitacoes/",file)
      dest_bid = paste0(path_zip_raw     ,  "/bid-",file,".zip")
      
      # Download if the compress file is not available 
      if (!file.exists(dest_bid))   download.file(URL_bid, dest=dest_bid, mode="wb") 
   }
  
  # Closing connection
  closeAllConnections()
}

# 2: Unzip ----
{
  # Folders inside the directory path
  files_list       <- dir(path_zip_raw)
  
  # unzip destination
  path_to_unzip <- file.path(path_project, 
                             "01-data", 
                             "04-output",
                             "01-data_temp",
                             "02-raw_uncompressed") 

  # Running loop to unzip all files downloaded
  for (file in files_list  ) {
    print(file) 
    if (str_sub(file,-3,-1)=="zip") {
      zipF<- file.path(path_zip_raw,file)
      archive_extract(zipF         , path_to_unzip)
    }
  }
  
  # Closing connection
  closeAllConnections()
} 

