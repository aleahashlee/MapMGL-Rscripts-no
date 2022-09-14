#packages needed for maps 


library(RPostgres)
library(dplyr)
library(tidyr)
library(leaflet)
library(RColorBrewer)



#options for different backgrounds
#note that some dont work for some reason so will have to play around with it
#https://leaflet-extras.github.io/leaflet-providers/preview/

#options for palette colours
#https://r-graph-gallery.com/38-rcolorbrewers-palettes

#colour options in r if you choose not to go with a categorical variable
#https://r-charts.com/colors/


#say we want to see fish with stock origin from Cowichan, Conumam Tahsis
factor_map(Stock_Origin=c("Cowichan","Conuma","Tahsis"))

#change colour
factor_map(Stock_Origin=c("Cowichan","Conuma","Tahsis"), 
           single_colour = "darkred")

#lets sort by species!
factor_map(Stock_Origin=c("Cowichan","Conuma","Tahsis"),
           chosen_factor = "common_name")

#terrible colours, maybe I dont like the background map?
factor_map(Stock_Origin=c("Cowichan","Conuma","Tahsis"),
           chosen_factor = "common_name", 
           colour_palette = "Dark2",background_map = "CartoDB.Positron")

#filter out coho...
factor_map(Stock_Origin=c("Cowichan","Conuma","Tahsis"), 
           species_values="Chinook", chosen_factor = "common_name", 
           colour_palette = "Dark2",background_map = "CartoDB.Positron")

#lets take a look at different factors! #SW_FW
factor_map(Stock_Origin=c("Cowichan","Conuma","Tahsis"), 
           species_values="Chinook", chosen_factor = "sw_fw", 
           colour_palette = "Dark2",background_map = "CartoDB.Positron")

#stock origin
factor_map(Stock_Origin=c("Cowichan","Conuma","Tahsis"), 
           species_values="Chinook", chosen_factor = "stock_origin", 
           colour_palette = "Dark2",background_map = "CartoDB.Positron")

#hatchery_yn
factor_map(Stock_Origin=c("Cowichan","Conuma","Tahsis"), 
           species_values="Chinook", chosen_factor = "hatchery_yn", 
           colour_palette = "Dark2",background_map = "CartoDB.Positron")

#year
factor_map(Stock_Origin=c("Cowichan","Conuma","Tahsis"), 
           species_values="Chinook", chosen_factor = "year", 
           colour_palette = "Dark2",background_map = "CartoDB.Positron")

#oh no!! error. Thats because the colour palette has less colours than the
#number of years(which is our chosen factor. Lets go back to the default colour 
#palette)

factor_map(Stock_Origin=c("Cowichan","Conuma","Tahsis"), 
           chosen_factor = "year",background_map = "CartoDB.Positron")


#lets see disease/microbe/ whatever other assay you are looking for, dont sort by anything
#This shows ce_sha OR c_b_cys!!
factor_map(Stock_Origin=c("Cowichan","Conuma","Tahsis"),background_map = "CartoDB.Positron",
           assay_names = c("ce_sha","c_b_cys"), CT_threshold = c(30,30))


#want ce_sha AND c_b_cys?
factor_map(Stock_Origin=c("Cowichan","Conuma","Tahsis"),background_map = "CartoDB.Positron",
           assay_names = c("ce_sha","c_b_cys"), CT_threshold = c(30,30) , or_assay_filter = FALSE)


#sort by stock origin
factor_map(Stock_Origin=c("Cowichan","Conuma","Tahsis"),background_map = "CartoDB.Positron",
           assay_names = c("ce_sha","c_b_cys"), CT_threshold = c(30,30) ,chosen_factor = "stock_origin",
           or_assay_filter = FALSE, colour_palette = "Dark2")



#lets check for errors?? #no longitude and latitude errors
factor_map(species_values = "Sockeye", years = 2020)

factor_map(species_values = "Sockeye",years = 2012)



#for Karia
factor_map(species_values = "Sockeye",assay_names = "te_mar", CT_threshold = 26.7, 
           chosen_factor = "sw_fw", colour_palette = "Dark2",background_map = "CartoDB.Positron" )


factor_map(species_values = "Sockeye",assay_names = "te_mar", CT_threshold = 26.7, 
           chosen_factor = "sw_fw", other_type = "rna_heart_yn", other_yn = TRUE,
           colour_palette = "Dark2",background_map = "CartoDB.Positron" )



factor_map(species_values = "Atlantic",assay_names = "te_mar", CT_threshold = 26.7, chosen_factor = "sw_fw",
           colour_palette = "Dark2", background_map = "CartoDB.Positron")


factor_map(species_values = "Atlantic",assay_names = "te_mar", CT_threshold = 26.7, chosen_factor = "sw_fw",
           colour_palette = "Dark2", background_map = "Stamen.Watercolor")





factor_map(species_value="Sockeye", other_type = "rna_gill_yn" , other_yn = TRUE)

#returns all... logic
factor_map(species_value="Sockeye", other_type = c("rna_gill_yn","stomach_yn") , 
           other_yn = c(TRUE,FALSE)) 

#thats better
factor_map(species_value="Sockeye", other_type = c("rna_gill_yn","stomach_yn") , other_yn = c(TRUE,FALSE), or_other_filter = FALSE) 


# look at ct map now


#look at all fish with te_mar under 30 ct
ct_colour_map(assay_name = "te_mar", CT_threshold = 30)

#all atlantics with te_mar less than 30 ct, lets change color palette
ct_colour_map(species_values = "Atlantic",assay_name = "te_mar", CT_threshold = 30, colour_palette = "Blues" )

#all atlantics with different background map... back to default colours

ct_colour_map(species_values = "Atlantic",assay_name = "te_mar", CT_threshold = 26.7, circle_size_change = TRUE,
              background_map ="CartoDB.Positron", colour_palette = "RdBu", other_type = c("rna_gill_yn","blood_yn"), other_yn = c(TRUE,TRUE))



ct_colour_map(species_values = "Atlantic",assay_name = "te_mar", CT_threshold = 26.7, circle_size_change = TRUE,
              background_map ="CartoDB.Positron", colour_palette = "RdBu", other_type = "rna_gill_yn", other_yn = TRUE)



data_lookup()
