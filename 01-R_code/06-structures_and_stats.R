## Made by Leandro Justino Pereira Veloso
## main: Harmonizing data
 
# 00: Function to create structure
arq_function <- function(data, rename_file) {
  
  # Creating data to keep the order variable
  data_output <- tibble(
    names = colnames(data)
  )
  
  # Getting stat
  aux_struct <-skim(data)   %>%  
    mutate(N_obs = nrow(data))   %>%
    relocate(skim_type, skim_variable, N_obs)
  
  # Joing with rename data
  aux_struct<- aux_struct %>%
    left_join(rename_file  , by=c("skim_variable"="new_names") ) %>%
    relocate( skim_variable,new_label, original_names , original_label ,skim_type  )
  
  # Joing with data_output to keep the order variable
  data_output <-data_output %>%
    left_join(aux_struct, by=c("names"="skim_variable"))
  
  return(data_output)
}

# 01: Tender architecture ---- 
{
  # Tender data
  tender_data_2015  <- 
      read_rds(file.path(path_project, "01-data", 
                        "02-import",
                        "01-tender-2015.rds") ) %>%
    as.data.table() 
 
  # Counting the number of obs by year
  tender_data_2015[,.N, by = "year_month"]
  
  # Reading the auxiliary rename file
  rename_tender <-  
    read_excel(file.path(path_github,"00-auxiliary_files",
                         "02-tender_rename_file.xlsx")
               , sheet = "01-tender-purchases",
    ) %>%  
    filter(!is.na(new_names))
  
  # Running function
  arq_tender  <- arq_function(data =tender_data_2015 , 
                              rename_file = rename_tender) 
}  

# 02: Tender-item architecture ---- 
{
  # Tender data
  tender_item_data_2015  <- 
    read_rds(file.path(path_project, "01-data", 
                       "02-import",
                       "02-tender-item-2015.rds")) %>%
    as.data.table()
  
  # Counting the number of obs by year
  tender_item_data_2015[,.N, by = "year_month"]
  
  # Reading the auxiliary rename file
  rename_tender_item <-  
    read_excel(file.path(path_github,"00-auxiliary_files",
                         "02-tender_rename_file.xlsx")
               , sheet = "02-tender-items",
    ) %>%  
    filter(!is.na(new_names))
  
  # Running function
  arq_tender_item  <- arq_function(data =tender_item_data_2015 , 
                              rename_file = rename_tender_item) 
}  

# 03: Tender-participant architecture ---- 
{
  # Tender data
  tender_participant_data_2015  <- 
    read_rds(file.path(path_project, "01-data", 
                       "02-import",
                       "03-tender-participants-2015.rds")) %>%
    as.data.table()
  
  # Counting the number of obs by year
  tender_participant_data_2015[,.N, by = "year_month"]
  
  # Reading the auxiliary rename file
  rename_tender_participant <-  
    read_excel(file.path(path_github,"00-auxiliary_files",
                         "02-tender_rename_file.xlsx")
               , sheet = "03-tender-participants",
    ) %>%  
    filter(!is.na(new_names))
  
  # Running function
  arq_tender_participant  <- arq_function(data =tender_participant_data_2015 , 
                                          rename_file = rename_tender_participant) 
}  

# 04: Tender-Efforts architecture ---- 
{
  # Tender data
  tender_efforts_data_2015  <- 
    read_rds(file.path(path_project, "01-data", 
                       "02-import",
                       "04-tender-efforts-2015.rds") ) %>%
    as.data.table() 
  
  # Counting the number of obs by year
  tender_efforts_data_2015[,.N, by = "year_month"]
  
  # Reading the auxiliary rename file
  rename_tender_efforts <-  
    read_excel(file.path(path_github,"00-auxiliary_files",
                         "02-tender_rename_file.xlsx")
               , sheet = "04-tender-effort",
    ) %>%  
    filter(!is.na(new_names))
  
  # Running function
  arq_tender_effort  <- arq_function(data =tender_efforts_data_2015 , 
                              rename_file = rename_tender_efforts) 
}  

# 05: UG data ---- 
{
  # Tender data
  ug_data   <- 
    read_rds(file.path(path_project, "01-data", 
                       "02-import",
                       "05-ug_data.rds") ) %>%
    as.data.table() 
  
  # Counting the number of obs by year
  ug_data[,.N, by = "ug_state"]
  
  # Reading the auxiliary rename file
  rename_ug <-  
    read_excel(file.path(path_github,"00-auxiliary_files",
                         "02-tender_rename_file.xlsx")
               , sheet = "01-tender-purchases",
    ) %>%  
    filter(!is.na(new_names))
  
  # Running function
  arq_ug  <- arq_function(data =ug_data , 
                              rename_file = rename_ug) 
}  

# 06: architecture  data ----
{
  # notes
  notes <- tibble(
    notes = c("bidder id has 14 digits when CNPJ and 11 when a CPF",
              "item id = 6 digits of the Managing Unit code + 2 digits of the procurement method + 5 digits of the tender number in the year + 4 digits of the tender year + 5 digits of the sequence identifying the item within the tender.",
              "The item value is estimated",
              "This dictionary was made using year ==2015")
  )
  
  # Export to excel
  write_xlsx(list( "01-tender"               = arq_tender
                  ,"02-tender-items"         = arq_tender_item
                  ,"03-tender-participants"  = arq_tender_participant
                  ,"04-tender-effort"        = arq_tender_effort
                  ,"05-ug_data"              = arq_ug
                  ,"06-notes"                = notes),
             path = file.path(path_github,"02-documentation", 
                              "01-architecture_tender.xlsx")) 
}
