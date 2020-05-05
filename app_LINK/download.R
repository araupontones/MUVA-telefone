library(tidyverse)
library(readxl)
library(httr)
library(jsonlite)
library(lubridate)
library(haven)

## read reference data
reference = read_rds("reference.rds")

##Set parameters -----------------------------------------------------------------------------------




#quesitonnaires to download
qn_variable <-c("follow_up_link") #using the questionnaire variable

#Server info
server <- "muva"
user <- "araupontones"  #API user in server
password <- "Seguridad1" #API password in server 
ex_type <- "stata" #format of your data
hq_address <- sprintf("https://%s.mysurvey.solutions", server)
downloadDir <- tempdir()



#Extract key variables of the quesionnaire

QuestionnaireId = "dd315878-fa0c-4750-880c-e5ffc3048a8c"
qn_id = "dd315878fa0c4750880ce5ffc3048a8c$4"
Version = "4"
Title = "FOLLOW  UP LINK"
Variable = "follow_up_link"

queryInfo <- sprintf("%s/api/v1/questionnaires",hq_address)
InfoServer <-  InfoServer <- GET(queryInfo, authenticate(user, password),
                                 query = list(limit = 200, offset = 4)) #successful

qnrList <- fromJSON(content(InfoServer, as = "text"), flatten = TRUE) 
ListOfQn.df <- as.data.frame(qnrList$Questionnaires) 


##Download data 



#download data



Pattern = paste(Variable, Version, sep = "_")
#create name of the zip file using the name of the questionnaire, version, and download file (this is espcified in the parameters)

zipfile <- paste0(Pattern,".zip")
zipfile <- file.path(downloadDir, zipfile) #folder to extract zip file

#folder where .zip is going to be extracted
exdir = str_remove(zipfile,".zip") 


queryGenerate <- sprintf("%s/api/v1/export/%s/%s/start", hq_address,
                         ex_type,qn_id)

generate <- POST(queryGenerate, authenticate(user, password))  #generate data in server
#print(paste("Generating", Title, Version, "in the server"))
Sys.sleep(5) #give the server time to generate the data


#query to download questionnaires
queryDownload <- sprintf("%s/api/v1/export/%s/%s", hq_address,ex_type, qn_id)

#get the url to download the files
download <- GET(queryDownload, authenticate(user, password), user_agent("andres.arau@outlook.com")) 
redirectURL <- download$url 


#Download the data uisng the redirected url
RawData <- GET(redirectURL) #Sucess!!


#open connection to write data in download folder
filecon <- file(zipfile, "wb") 
#write data contents to download file!! change unzip folder to temporary file when in shiny
writeBin(RawData$content, filecon) 
#close the connection
close(filecon)

#unzip


#unizp questionnaires
#tounzip = file.path(downloadDir,"follow_up_link_2.zip")


unzip(zipfile=zipfile, overwrite = TRUE, 
      exdir = exdir, 
      unzip = "internal"
     )




junk <- dir(path=downloadDir, pattern=".zip|.do|Pdf") # ?dir
file.remove(paste(downloadDir,junk, sep = "\\")) # ?file.remove


##read data -----------------------------------------------------------------------

#main questionnaire
file = file.path(exdir,"follow_up_link.dta")




qn = read_dta(file) 

to_label = c("chamada_status", "Nome", "id_number", "name_entrevistador")

for(var in to_label){
  a=  attributes(qn[[var]])
  l = a$labels
  lbl = names(l)
  
  qn[var] = factor(qn[[var]],
                   levels = l,
                   labels = lbl)
}



ligados = qn %>%
  mutate(link = paste0('<a href="https://muva.mysurvey.solutions/Interview/Review/',
                       interview__id,
                       '" target="_blank">Link</a>')) %>%
  select(id_number, chamada_status,name_entrevistador, CHAMADA_concl,Hora, link) %>%
  rename(ID = id_number,
         Status = chamada_status)


#

tabla = full_join(reference, ligados, by="ID") %>%
  select(ID, Nome, Status,name_entrevistador, CHAMADA_concl,Hora, link) 


