## Made by Leandro Justino Pereira Veloso
## main: Harmonizing data
 
# 01: Auxiliary information ----
{
  data_purchase_methods <- 
    tibble(
      purchase_method_code_aux    =c("01", "02", "03", "03", "04", "04", "05", "05", "06", "07", "20", "22", "33", "44"),
      purchase_method_name = c( 
        "Convite"											, 
        "Tomada de Preços"	                                , 
        "Concorrência"                                     , 
        "concorrencia - registro de preco"                 , 
        "Concorrência Internacional"                       , 
        "concorrencia internacional - registro de preco"   , 
        "Pregão"                                           , 
        "Pregão - registro de preco"                       , 
        "Dispensa de Licitação"                            , 
        "Inexigibilidade de Licitação"                     , 
        "Concurso"                                         , 
        "Tomada de Preços por Técnica e Preço"             , 
        "Concorrência por Técnica e Preço"                 , 
        "Concorrência Internacional por Técnica e Preço"   )
    )
  
  data_purchase_methods = 
    data_purchase_methods %>%
    mutate(purchase_method_name  = clean_strings(purchase_method_name, 
                                                 rm_pontuation = FALSE) )
  
}

# 02: Tender (bidding process) by year ---- 
{
  path_tender_purchases   = file.path(dir_raw_data, "01-tender-purchases")   
  
  year_list  = unique(year(sequence_dates))
  
  # Creating list to save all data
  tender_year_list = list()
  for (year in year_list ) {
    # Pattern files
    paste0(".", year, "." )
    list_file <- list.files(path_tender_purchases, pattern = pattern_str, full.names = FALSE)
    
    # Empty list to save files
    tender_month_list<- list()
    
    # Running all months available for such year
    for (file in list_file) {
      
      # 1: Reading raw file
      { 
        # print(file)
        month <- substr(file, 13, 14)
        
        # Printing file
        print(paste(file, "; year:", year , "; month: ",month), quote = FALSE)
        
        # reading raw file
        tender_raw = fread(file.path(path_tender_purchases,file),
                           encoding = "Latin-1",colClasses = "character") 
        
        # example to test
        colnames(tender_raw) <- clean_strings(colnames(tender_raw), TRUE)
      }
      
      # 2: Cleaning all strings (lower, accent, spaces)
      for (var in colnames(tender_raw)) {
        # Cleanning
        tender_raw[[paste0(var)]] <- clean_strings(tender_raw[[paste0(var)]] , FALSE)
      }
      
      # 3: Renaming from file
      { 
        # List of existing variables
        filter_var_names= colnames(tender_raw)
        
        # Load the list of original names and R names
        rename_variables <-  
          read_excel(file.path(path_github,"00-auxiliary_files",
                               "02-tender_rename_file.xlsx")
                     , sheet = "01-tender-purchases",
          ) %>% 
          filter(original_names %in% filter_var_names) %>%
          filter(!is.na(new_names))
        
        # Apply the changes listed in the Excel file
        tender_month_list[[paste0(year,month)]] <-
          tender_raw %>%
          rename(!!set_names(rename_variables$original_names, 
                             rename_variables$new_names))
      }
    }
    
    # Append all months of a same year
    tender_year_list[[paste0(year)]] <-
      rbindlist(tender_month_list, fill = TRUE, idcol="year_month") 
    
    # Adjusting formats
    tender_year_list[[paste0(year)]] <-
      tender_year_list[[paste0(year)]] %>%
      mutate(tender_amount = as.numeric(str_replace(tender_amount, 
                                                    pattern = ",", 
                                                    replacement=".")),
             # date format
             tender_date_result = dmy(tender_date_result),
             tender_date_open   = dmy(tender_date_open) ) %>%
      relocate(tender_id, year_month,ug_id , purchase_method_code, purchase_method_name )
    
    # Adjust tender id ( getting )
    tender_year_list[[paste0(year)]] <- tender_year_list[[paste0(year)]] %>%
      left_join(data_purchase_methods, by = "purchase_method_name") %>%
      mutate(tender_id = str_c(ug_id, purchase_method_code_aux, tender_id)) %>%
      select(-purchase_method_code_aux) 
    
    # No duplications
    print(sum(duplicated(tender_year_list[[paste0(year)]]$tender_id)))
    
    # If exist it is too few, dropping anyway
    tender_year_list[[paste0(year)]] <- tender_year_list[[paste0(year)]] %>%
        distinct(tender_id ,.keep_all= TRUE)
    
    # Saving file
    tender_year_list[[paste0(year)]] %>%
      # Filtering variables
      select(tender_id, year_month, purchase_method_code, purchase_method_name,
             ug_id,process_id, starts_with("tender_"))      %>%
      write_rds(file.path(path_project, "01-data", 
                          "02-import",paste0("01-tender-",year,".rds")),
                compress = "gz") 
  }
}  

# 03: UG data ---- 
{
  # Append all months of a same year
  tender_panel <-
    rbindlist(tender_year_list, fill = TRUE, idcol="year") %>%
    select( starts_with("ug_")  )
  
  # All ug variable is level of ug 
  { 
    distinct(tender_panel,ug_id) %>% count()
  
    distinct(tender_panel) %>%  count()
  }
  
  # Creating manage unit data 
  ug_data = tender_panel %>%
    distinct(ug_id, .keep_all = TRUE) 
  
  # Exporting data
  ug_data %>%  
      write_rds(file.path(path_project, "01-data", 
                          "02-import",paste0("05-ug_data.rds")),
                compress = "gz") 
}  

# 04: item (lot) Tender level by year ---- 
{
  # path
  path_tender_items       = file.path(dir_raw_data, "02-tender-items")       
  
  # year list based in the master file sequence
  year_list  = unique(year(sequence_dates))
  
  # Creating list to save all data
  for (year in year_list ) {
    # Pattern files
    paste0(".", year, "." )
    list_file <- list.files(path_tender_items, pattern = pattern_str, full.names = FALSE)
    
    # Empty list to save files
    tender_item_month_list<- list()
    
    # Running all months available for such year
    for (file in list_file) {
      
      # 1: Reading raw file
      { 
        # print(file)
        month <- substr(file, 18, 19)
        
        # Printing file
        print(paste(file, "; year:", year , "; month: ",month), quote = FALSE)
        
        # reading raw file
        tender_item_raw = fread(file.path(path_tender_items,file),
                           encoding = "Latin-1",colClasses = "character") 
        
        # example to test
        colnames(tender_item_raw) <- clean_strings(colnames(tender_item_raw), TRUE)
      }
      
      # 2: Cleaning all strings (lower, accent, spaces)
      for (var in colnames(tender_item_raw)) {
        # Cleanning
        tender_item_raw[[paste0(var)]] <- clean_strings(tender_item_raw[[paste0(var)]] , FALSE)
      }
      
      # 3: Renaming from file
      { 
        # List of existing variables
        filter_var_names= colnames(tender_item_raw)
        
        # Load the list of original names and R names
        rename_variables <-  
          read_excel(file.path(path_github,"00-auxiliary_files",
                               "02-tender_rename_file.xlsx")
                     , sheet = "02-tender-items",
          ) %>% 
          filter(original_names %in% filter_var_names) %>%
          filter(!is.na(new_names))
        
        # Apply the changes listed in the Excel file
        tender_item_month_list[[paste0(year,month)]] <-
          tender_item_raw %>%
          rename(!!set_names(rename_variables$original_names, 
                             rename_variables$new_names))
      }
    }
    

    
    # Append all months of a same year
    tender_item_year_list  <-
      rbindlist(tender_item_month_list, fill = TRUE, idcol="year_month") %>%
      select(year_month, item_id,item_5d_name, item_qtd, item_value,bidder_id, bidder_name ) %>%
        mutate(tender_id = substr(item_id,1,17),
               ug_id     = substr(item_id,1,6)) %>%
      relocate(year_month, item_id, tender_id, ug_id, 
               item_qtd, item_value,bidder_id, bidder_name,item_5d_name) %>%
        arrange(year_month,ug_id,tender_id,item_id )
    
    tender_item_year_list %>%
      filter(item_id=="") %>%
      count(year_month)
    
    # since is not common, duplicates ( It is possible two winners)  
      tender_item_year_list <-
        filter(tender_item_year_list,item_id!="") %>%
          group_by(item_id) %>%
          mutate(winner_id = n() ) %>%
        ungroup()      %>%
        relocate(year_month, item_id, item_id, winner_id)
      
    # Adjusting formats
    tender_item_year_list <-tender_item_year_list  %>%
      mutate(item_value = as.numeric(str_replace(item_value, 
                                                    pattern = ",", 
                                                    replacement=".")),
             item_qtd   = as.numeric(str_replace(item_qtd , 
                                                 pattern = ",", 
                                                 replacement="."))
      )
    
    # Saving file
    tender_item_year_list %>%
      write_rds(file.path(path_project, "01-data", 
                          "02-import",paste0("02-tender-item-",year,".rds")),
                compress = "gz") 
  }
}  

# 05: Participants X item X Tender level by year ---- 
{
  # path
  path_tender_participants       = file.path(dir_raw_data, "03-tender-participants")     
  
  # year list based in the master file sequence
  year_list  = unique(year(sequence_dates))
  
  # Creating list to save all data
  for (year in year_list ) {
    # Pattern files
    paste0(".", year, "." )
    list_file <- list.files(path_tender_participants , pattern = pattern_str, full.names = FALSE)
    
    # Empty list to save files
    tender_participants_month_list<- list()
    
    # Running all months available for such year
    for (file in list_file) {
      
      # 1: Reading raw file
      { 
        # print(file)
        month <- substr(file, 29, 30)
        
        # Printing file
        print(paste(file, "; year:", year , "; month: ",month), quote = FALSE)
        
        # reading raw file
        tender_participants_raw = fread(file.path(path_tender_participants ,file),
                                encoding = "Latin-1",colClasses = "character") 
        
        # example to test
        colnames(tender_participants_raw) <- clean_strings(colnames(tender_participants_raw), TRUE)
      }
      
      # 2: Renaming from file
      { 
        # List of existing variables
        filter_var_names= colnames(tender_participants_raw)
        
        # Load the list of original names and R names
        rename_variables <-  
          read_excel(file.path(path_github,"00-auxiliary_files",
                               "02-tender_rename_file.xlsx")
                     , sheet = "03-tender-participants",
          ) %>% 
          filter(original_names %in% filter_var_names) %>%
          filter(!is.na(new_names))
        
        # Apply the changes listed in the Excel file
        tender_participants_month_list[[paste0(year,month)]] <-
          tender_participants_raw %>%
          rename(!!set_names(rename_variables$original_names, 
                             rename_variables$new_names)) %>%
          select(item_id, bidder_id, D_winner) %>%
          mutate(D_winner = str_to_lower(D_winner) =="sim")
      }
    }
    
    # Append all months of a same year
    tender_participants_year_list  <-
      rbindlist(tender_participants_month_list, fill = TRUE, idcol="year_month") %>%
      relocate(year_month, item_id,bidder_id, D_winner) %>%
      arrange(year_month, item_id, -D_winner )
    
    # Dropping if item is wrong size
    tender_participants_year_list[str_length(item_id)!=22,.N]
    
    # Saving file
    tender_participants_year_list[str_length(item_id)==22] %>%
       write_rds(file.path(path_project, "01-data", 
                          "02-import",paste0("03-tender-participants-",year,".rds")),
                compress = "gz") 
  }
}  

# 06: Efforts by year ---- 
{
  # path
  path_tender_effort      = file.path(dir_raw_data, "04-tender-effort")  
  
  # year list based in the master file sequence
  year_list  = unique(year(sequence_dates))
  
  # Creating list to save all data
  for (year in year_list ) {
    # Pattern files
    paste0(".", year, "." )
    list_file <- list.files(path_tender_effort , pattern = pattern_str, full.names = FALSE)
    
    # Empty list to save files
    tender_effort_month_list<- list()
    
    # Running all months available for such year
    for (file in list_file) {
      
      # 1: Reading raw file
      { 
        # print(file)
        month <- substr(file, 20, 21)
        
        # Printing file
        print(paste(file, "; year:", year , "; month: ",month), quote = FALSE)
        
        # reading raw file
        tender_effort_raw = fread(file.path(path_tender_effort ,file),
                                        encoding = "Latin-1",colClasses = "character") 
        
        # example to test
        colnames(tender_effort_raw) <- clean_strings(colnames(tender_effort_raw), TRUE)
      }
      
      # 2: Cleaning all strings (lower, accent, spaces)
      for (var in colnames(tender_effort_raw)) {
        # Cleanning
        tender_effort_raw[[paste0(var)]] <- clean_strings(tender_effort_raw[[paste0(var)]] , FALSE)
      }
      
      # 3: Renaming from file
      { 
        # List of existing variables
        filter_var_names= colnames(tender_effort_raw)
        
        # Load the list of original names and R names
        rename_variables <-  
          read_excel(file.path(path_github,"00-auxiliary_files",
                               "02-tender_rename_file.xlsx")
                     , sheet = "04-tender-effort",
          ) %>% 
          filter(original_names %in% filter_var_names) %>%
          filter(!is.na(new_names))
        
        # Apply the changes listed in the Excel file
        tender_effort_month_list[[paste0(year,month)]] <-
          tender_effort_raw %>%
          rename(!!set_names(rename_variables$original_names, 
                             rename_variables$new_names))  
      }
    }

    # Append all months of a same year
    tender_effort_year_list  <-
      rbindlist(tender_effort_month_list, fill = TRUE, idcol="year_month") %>%
      left_join(data_purchase_methods, by = "purchase_method_name") %>%
      mutate(tender_id = str_c(ug_id, purchase_method_code_aux, tender_id))  %>%
      select(year_month, tender_id, ug_id, starts_with("effort_")  )
    
    # Adjust tender id ( getting )
    tender_effort_year_list <-    tender_effort_year_list %>%
      mutate(effort_amount = as.numeric(str_replace(effort_amount, 
                                      pattern = ",", 
                                      replacement=".")),
          # date format
          effort_date_start  = dmy(effort_date_start )) 
 
    # Saving file
    tender_effort_year_list %>%
      write_rds(file.path(path_project, "01-data", 
                          "02-import",paste0("04-tender-efforts-",year,".rds")),
                compress = "gz") 
  }
}  
