# Made by Leandro Veloso
# main: Download and clean the tender data for general use in research projects
# Data source: https://portaldatransparencia.gov.br

# 0: Setting R ----
{
  # 1: Cleaning R
  rm(list=ls()) 
  
  # 2: Loading package
  {
    # 2: Loading package
    {
      packages <- 
        c( 
          # 01: Classic packages for data manipulation
          "tidyverse",
          "data.table",
          # 02: Text manupulation pacages
          "stringr",
          "stringi",
          "rebus",
          "tm",
          # 03: Date formats
          "lubridate",
          # 04: Reading/writting xls,xlsx
          "readxl",
          "writexl",
          # 05: Labelling from auxiliar file
          "labelled",
          # 06: Nice statitics
          "skimr",
          # 07: Compress files
          "archive",
          "cli",
          "R.utils"
        ) 
      
      # Leitura dos pacotes e dependencias
      if (!require("pacman")) install.packages("pacman")
      
      # Loading list of packages
      pacman::p_load(packages,
                     character.only = TRUE,
                     install = TRUE)
    }
    
    # Leitura dos pacotes e dependencias
    if (!require("pacman")) install.packages("pacman")
    
    # Loading list of packages
    pacman::p_load(packages,
                   character.only = TRUE,
                   install = TRUE)
  }

  # 3: Setting path according to user
  if (Sys.getenv("USERNAME") == "leand") {
    print("Leandro user has been selected")
    path_project <- "C:/Users/leand/Dropbox/3-Profissional/07-World BANK/04-procurement/01-dados/01-Brasil/01-portal_da_transparencia"
    path_github  <- "C:/Users/leand/Dropbox/3-Profissional/17-Github/04-WGB/01-procurement/01-procurement-data-preparation/01-Brazil"
  }  else if (Sys.getenv("USERNAME") == "wb543303") {
    print("Leandro WGB notebook user has been selected")
    path_project  <- "C:/Users/wb543303/Documents/01-out_one_drive/03-temporary_files/02-procurement_data"
    path_github   <- "C:/Users/wb543303/Documents/01-out_one_drive/01-Github/01-Personal/Adm_data_project-03-Portal-transparencia"
  } 
  
  # 4: Defying range files
  {
    # first month/year - MM/01/YYYY
    year_month_start = mdy("01/01/2013")
    year_month_end   = mdy("12/01/2022")
    
    # To use in the loop
    sequence_dates <- seq.Date( from = year_month_start,
                                to = year_month_end,
                                by = 'months')
    
    # N months
    range_months<- interval(year_month_start, year_month_end) %/% months(1)  
    print(sample(sequence_dates, size=10))
  }
  
  # 5: Folder creation
  {
    # folder creation
    dir.create(file.path(path_project, "01-data")    ,  showWarnings = FALSE)
    dir.create(file.path(path_project, "01-data", "01-raw")    ,  showWarnings = FALSE)
    dir.create(file.path(path_project, "01-data", "02-import") ,  showWarnings = FALSE)
    dir.create(file.path(path_project, "01-data", "03-clean")  ,  showWarnings = FALSE)
    dir.create(file.path(path_project, "01-data", "04-output") ,  showWarnings = FALSE)
    dir.create(file.path(path_project, "01-data", "04-output","01-data_temp") ,  showWarnings = FALSE)
    dir.create(file.path(path_project, "01-data", "04-output","01-data_temp","01-raw_compressed") ,  showWarnings = FALSE)
    dir.create(file.path(path_project, "01-data", "04-output","01-data_temp","02-raw_uncompressed") ,  showWarnings = FALSE)
    dir.create(file.path(path_project, "01-data", "04-output","02-tables") ,  showWarnings = FALSE)
    dir.create(file.path(path_project, "01-data", "04-output","03-figures") ,  showWarnings = FALSE)
  }
}

# 1: Auxiliary function ----
{
  # 1: Clean string
  clean_strings = function(var,rm_pontuation = FALSE) { 
    # Removing all that is not letter or number or space
    pattern_all_not_letter_numbers =  "[^a-zA-Z0-9 ]"
    
    #  Change LATIN to ASCII
    if (rm_pontuation == FALSE) {
      str_trim( 
        stripWhitespace( 
          tolower(
            stri_trans_general(str = var, 
                               id = "Latin-ASCII")))
        , side = c("both")) 
    } else { 
      str_trim( 
        stripWhitespace( 
          str_replace_all(
            tolower(
              stri_trans_general(str = var, 
                                 id = "Latin-ASCII")
            )
            
            ,  
            pattern = pattern_all_not_letter_numbers, 
            replace=" "
          )
        )
        ,side = c("both"))
    }
  }
  
  # An example
  example = c(" PAPEL COUCHÊ _)*" , "Lente intraocular  mono   ",
              "A, B, C. ETsats!","12-1654-LP15")
  
  #checking function
  clean_strings(example)
  clean_strings(example, TRUE)

}

# 2: Raw organization ----
{
  # 2.1 Download the data from portal da transparencia and unzip it
  source(file.path(path_github,"01-R_code",
                               "01-Download-porta_transparencia.r"))
  
  # 2.2: Rename the Tender data and allocate for selected folder in 01-data/01-raw in gz format
  source(file.path(path_github,"01-R_code",
                   "02-Tender-organization-raw.R"))
  
  # 2.3: Removing original files downloaded in "01-Download-porta_transparencia.r"
  source(file.path(path_github,"01-R_code",
                   "03-Deleting-extra-files.R"))
}

# 3: Data Harmonization ----
{
  # 3.1 Reading all tender data to export all variables names.
  #     If 02-tender_rename_file.xlsx already created it may not
  #     necessary to run it again.
  source(file.path(path_github,"01-R_code",
                   "04-Getting-all-variable-names-in-data.R"))
  
  # 3.2 Harmonizing data and saving in R
  source(file.path(path_github,"01-R_code",
                   "05-Harmonize-tender-data.R"))
  
  # 3.3 Structure and minor statistics
  source(file.path(path_github,"01-R_code",
                   "06-Harmonize-tender-data.R"))
  
}