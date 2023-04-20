# 1: Introduction

This data project aims to clean the tender data from Brazil's federal public expenses, which can be found on the public [Transparency Portal](https://portaldatransparencia.gov.br/download-de-dados) (known as "Portal da transparência" in Portuguese). In Brazil, federal government purchases are managed through the SIASG system (short for "Sistema Integrado de Administração e Serviços Gerais" in Portuguese). The Transparency Portal provides access to a rich set of data information from SIASG, including the universe of the bidding process and contracts. 

This data work was made in R. It downloads the monthly compress data Transparency Portal and them clean it the data separating it in 5 dataset level which is harmonized names and adjusts formats, avoiding any major filter to keep the original major structure. The main output of this data project are the following data sets:

*  **01-tender-YYYY** - It is a yealy data on tender process level. Where we have overall information about the bidding process such as tender method, total amount, bidding, buyer and dates of open and results.
*  **02-tender-item-YYYY** -  For each tender process we have a set of lots (items) that compose this tender. This data has information of each item, your description, quantity pruchase, estimated value, and finally the winner information.
*  **03-tender-participants-YYYY** - Competition happens at the \textbf{item or lot level}- This data has the identification of each participants in a lot/tender.
*  **04-tender-efforts-YYYY** - data of "nota de empenho" - an short invoice that preecede the purchase.
*  **05-ug_data** - this data contains the information of manage unit that is responsable for the tender process. It has information about manage unit, organ, top organ and finally the location.


# 2: Code struture

The coding flux is made by a master file code call "01-Master_tender_data_harmonization.R" that are responsable for the following functions:
* Load Packages. ** It is necessary to install Rtools (R version>=4.2)** 
* Define main paths
* Create the folder structure of the project if it is not done.
* Define the period that the data will clean
* Declarate functions that are used in all project
* Run all scripts in the correct order that is into the folder "01-R_code"

The codes are separated in two categories:
* **Raw organization** : It download the data and reorganize the raw in foders for each it module in a way to become easy to manage the raw files.
* **Data Harmonization**: It cleans the dataset and harmonize names to general use.





The code inside this folder, `1-import`, is destinate to read the raw files and harmonize the files. It means, adjust names, labels, formats and minor cleannings.
The main idea is that we have a set of data in dta/rds format that we can easy merge and append to create the data we requires for our astudy.

# 2: Source data

Federal public procurement in Brazil has three main source, two of them is public and one is restrict. The SIASG is a system that allows for all stages of the bidding process, from the preparation of the notice to the approval of the result. Information on bidding processes, such as bidding modalities used, contract values, participants, and winning companies, are recorded in this system.



## 2.1 Procurement data

* [Portal da transparência](https://www.portaltransparencia.gov.br/origem-dos-dados): A website that we have access to the the SIASG
federal expense composition. It allows to download data of tenders and contracts monthly. 
* [Compras dados](http://compras.dados.gov.br/): It is a website that allows to download almost every piece of information in the tender procces. However,
it is quite more difficult to download the data.
* SIASG datawarehouse: this is the original source that has restrict access.

##  2.2 Product Classification 
The procurement processes dataset and the contracts dataset contain detailed information on purchased items. Items are classified using the CATSER (catálogo de serviços) catalog for service, and the CATMAT (catálogo de materiais) catalog for goods.  Using these classifications, it is possible categorizes items in some agreagation level. 

Download option:
* [CATMAT/CATSER](https://www.gov.br/compras/pt-br/acesso-a-informacao/consulta-detalhada/planilha-catmat-catser): www.gov.br
* [CATMAT](http://compras.dados.gov.br/docs/lista-metodos-materiais.html): compras.dados.gov
* [CATSER](http://compras.dados.gov.br/docs/lista-metodos-servicos.html): compras.dados.gov

### [CATMAT](https://www.gov.br/saude/pt-br/acesso-a-informacao/gestao-do-sus/economia-da-saude/banco-de-precos-em-saude/catalogo-de-materiais-2013-catmat)
  Goods are detailed up to 6 digits levels. The materials are classifications that are aggregable by 2, 3, and 5 digits level.
https://www.gov.br/compras/pt-br/acesso-a-informacao/consulta-detalhada/planilha-catmat-catser/view 

### [CATSER](http://compras.dados.gov.br/): 
  Services are detailed up to 5 digits levels. The materials are classifications that are aggregable by 1, 2, 3, and 4 digits level.
 
# 3: Programs

The import proccess were made in the KCP project and FA project.=
