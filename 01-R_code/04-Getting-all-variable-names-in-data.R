## Made by Leandro Justino Pereira Veloso
## main: Checking all files variables name

# 01: Variable original names - tender-purchases
{ 
  # path
  path_tender_purchases   = file.path(dir_raw_data, "01-tender-purchases")   

  # Listing all files in the folder
  list_file <- list.files(path_tender_purchases, full.names = FALSE)
  
  # Reading the first 1000 rows of each file to get the name
  tender_vars_names <- ""
  for (file_tender in list_file) { 
    # Only 1000 first lines
    tender_sample = fread(file.path(path_tender_purchases,file_tender),nrows=1000,
                          encoding = "Latin-1",colClasses = "character") 
    
    # Appending the colnames data
    tender_vars_names <- c(tender_vars_names,colnames(tender_sample)) 
  }
  
  # Removing special characters & removing duplicated names
  tender_unique_name_var = unique(clean_strings(tender_vars_names, TRUE))
  print(length(tender_unique_name_var))
}

# 02: Variable original names - tender-items
{ 
  # path
  path_tender_items       = file.path(dir_raw_data, "02-tender-items")       
  
  # Listing all files in the folder
  list_file <- list.files(path_tender_items, full.names = FALSE)
  
  # Reading the first 1000 rows of each file to get the name
  tender_item_vars_names <- ""
  for (file_item in list_file) { 
    # Only 1000 first lines
    tender_item_sample = fread(file.path(path_tender_items,file_item),nrows=1000,
                          encoding = "Latin-1",colClasses = "character") 
    
    # Appending the colnames data
    tender_item_vars_names <- c(tender_item_vars_names,colnames(tender_item_sample)) 
  }
  
  # Removing special characters & removing duplicated names
  tender_item_unique_name_var = unique(clean_strings(tender_item_vars_names, TRUE))
  print(length(tender_item_unique_name_var))
}

# 03: Variable original names - tender-participants
{ 
  # path
  path_tender_participants       = file.path(dir_raw_data, "03-tender-participants")     
  
  # Listing all files in the folder
  list_file <- list.files(path_tender_participants, full.names = FALSE)
  
  # Reading the first 1000 rows of each file to get the name
  tender_participants_vars_names <- ""
  for (file_participants in list_file) { 
    # Only 1000 first lines
    tender_participants_sample = fread(file.path(path_tender_participants,
                                                 file_participants),nrows=1000,
                               encoding = "Latin-1",colClasses = "character") 
    
    # Appending the colnames data
    tender_participants_vars_names <- c(tender_participants_vars_names,
                                        colnames(tender_participants_sample)) 
  }
  
  # Removing special characters & removing duplicated names
  tender_participants_unique_name_var = unique(clean_strings(tender_participants_vars_names, TRUE))
  print(length(tender_participants_unique_name_var))
}

# 04: Variable original names - tender-effort
{ 
  # path
  path_tender_effort      = file.path(dir_raw_data, "04-tender-effort")      
  
  # Listing all files in the folder
  list_file <- list.files(path_tender_effort, full.names = FALSE)
  
  # Reading the first 1000 rows of each file to get the name
  tender_effort_vars_names <- ""
  for (file_effort in list_file) { 
    # Only 1000 first lines
    tender_effort_sample = fread(file.path(path_tender_effort,
                                                 file_effort),nrows=1000,
                                       encoding = "Latin-1",colClasses = "character") 
    
    # Appending the colnames data
    tender_effort_vars_names <- c(tender_effort_vars_names,
                                        colnames(tender_effort_sample)) 
  }
  
  # Removing special characters & removing duplicated names
  tender_effort_unique_name_var = unique(clean_strings(tender_effort_vars_names, TRUE))
  print(length(tender_effort_unique_name_var))
}

# 05: Variable original names - tender-effort
{
  write_xlsx(list("01-tender-purchases"    = tibble( original_names =tender_unique_name_var
                                                    ,new_names      =""	
                                                    ,original_label ="" 	
                                                    ,new_label      ="" ),
                  "02-tender-items"        = tibble( original_names =tender_item_unique_name_var
                                                       ,new_names      =""	
                                                       ,original_label ="" 	
                                                       ,new_label      ="" ),
                  "03-tender-participants" = tibble( original_names =tender_participants_unique_name_var
                                                       ,new_names      =""	
                                                       ,original_label ="" 	
                                                       ,new_label      ="" ),
                  "04-tender-effort"       = tibble( original_names =tender_effort_unique_name_var
                                                       ,new_names      =""	
                                                       ,original_label ="" 	
                                                       ,new_label      ="" )
                 ),
             path = file.path(path_github,
                              "00-auxiliary_files",
                              "01-tender_base_colnames_to_rename.xlsx")
             ) 
  }