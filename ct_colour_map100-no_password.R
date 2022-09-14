

ct_colour_map<-function(species_values=NULL, assay_name=NULL, other_type= NULL, CT_threshold=NULL, other_yn=NULL, years=NULL,
                        hatchery=NULL, Stock_Origin=NULL,salinity=NULL, circle_size_change=FALSE,
                        background_map='Esri.NatGeoWorldMap', colour_palette="RdBu", circle_size=5000, 
                        circle_weight=3, circle_opacity=0.75, popup_name=NULL, legend_title=NULL){
  
  
  
  #load from database
  #removed for privacy
  
  #retrieving data 
  res <- dbSendQuery(con, "SELECT species_id, common_name FROM r_species")
  
  
  species<-dbFetch(res) #creating data frame with fields as species_id and common_name
  
  
  dbClearResult(res)
  
  
  #load more from db
  #removed for privacy
  
  
  #retrieving all data from temp_meta_pivot tables
  res <- dbSendQuery(con, "SELECT * FROM temp_meta_pivot")
  
  metadata_table<-dbFetch(res) #creating data frame
  
  
  dbClearResult(res)
  
  
  #join temp_meta_pivot table with species table to add common names
  all.df<-left_join(metadata_table,species, by="species_id")
  
  
  #create list of all column names
  
  
  #create new df with only parameters of interest
  new.df<-all.df[c(c("common_name","year","hatchery_yn","stock_origin","longitude",'latitude','sw_fw'),assay_name,other_type)]
  
  filtered_df<-new.df
  #print(new.df)
  
  #filter out with specified species
  if (missing(species_values)) filtered_df #returns everything in dataframe if argument is not specified
  else filtered_df<-filter(filtered_df, common_name %in% species_values)
  
  
  if (missing(years)) filtered_df #continue ot update the filter.param dataframe
  else filtered_df<-filtered_df %>%
    filter(year %in% years)
  
  if (missing(hatchery)) filtered_df
  else filtered_df<-filtered_df %>% 
    filter(hatchery_yn %in% hatchery)
  
  if (missing(Stock_Origin)) filtered_df
  else filtered_df<-filtered_df %>% 
    filter(stock_origin %in% Stock_Origin)
  
  if (missing(salinity)) filtered_df
  else filtered_df<-filtered_df %>% 
    filter(sw_fw %in% salinity)
  
  #dealing with other filter
  #filtered_df<-filter(filtered_df , filtered_df[other_type==other_yn])
  
  #dealing with other filters
  index<-0
  for (i in other_type){
    index<-index + 1
    filtered_df<-filter(filtered_df , filtered_df[other_type[index]]==other_yn[index])
    }
  
  

  #filtering assays with ct level less than threshold
  filtered_df<-filter(filtered_df,filtered_df[assay_name]<=CT_threshold)
  
  
  
  
  
  
  print("summary statistics before removing N/A's")
  print(summary(filtered_df))
  View(filtered_df)
  
  #converting longitude and latitude to numeric values
  
  filtered_df$longitude<-as.numeric(filtered_df$longitude) 
  filtered_df$latitude<-as.numeric(filtered_df$latitude) 
  
  #getting rid of any NA's for longitude and latitude columns
  filtered_df<-filtered_df[!is.na(filtered_df$longitude),]
  filtered_df<-filtered_df[!is.na(filtered_df$latitude),]
  filtered_df<-filtered_df[!is.na(filtered_df[assay_name]),]
  
  
  long<-filtered_df$longitude #assigning variable names
  lat<-filtered_df$latitude 
  
  #creating colour palette
  pal <- colorNumeric(palette = colour_palette , domain = filtered_df[,assay_name], reverse = TRUE)
  
  if (circle_size_change==TRUE){
    
    fish_map <- leaflet() %>%
      addProviderTiles(background_map) %>%  # use the default base map which is OpenStreetMap tiles
      addCircles(data= filtered_df,
                 lng= long, lat= lat,
                 radius = (1/sqrt(filtered_df[,assay_name]))*30000,
                 weight = circle_weight,
                 fillOpacity = circle_opacity,
                 popup = popup_name,
                 color = pal(filtered_df[,assay_name]),
                 labelOptions(interactive=TRUE,
                              clickable=TRUE)
      ) 
    fish_map %>%
      addLegend("bottomright", pal=pal, values=filtered_df[,assay_name],
                opacity = 1, title = legend_title)

    
    
  } else {
    fish_map <- leaflet() %>%
      addProviderTiles(background_map) %>%  # use the default base map which is OpenStreetMap tiles
      addCircles(data= filtered_df,
                 lng= long, lat= lat,
                 radius = circle_size,
                 weight = circle_weight,
                 fillOpacity = circle_opacity,
                 popup = popup_name,
                 color = pal(filtered_df[,assay_name]),
                 labelOptions(interactive=TRUE,
                              clickable=TRUE)
      ) 
    fish_map %>%
      addLegend("bottomright", pal=pal, values=filtered_df[,assay_name],
                opacity = 1, title = legend_title)
    
  }

}





