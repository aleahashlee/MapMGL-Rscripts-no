


factor_map<-function(species_values=NULL, assay_names=NULL, other_type= NULL, CT_threshold=NULL, other_yn=NULL, years=NULL,
                   hatchery=NULL, Stock_Origin=NULL,salinity=NULL, or_assay_filter=TRUE, chosen_factor=NULL,
                   background_map='Esri.NatGeoWorldMap', colour_palette="Paired", circle_size=5000,
                   circle_weight=3, circle_opacity=0.75, single_colour="Hotpink",
                   popup_name=NULL, legend_title=NULL){
  
  
  #load from db
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
  new.df<-all.df[c(c("common_name","year","hatchery_yn","stock_origin","longitude",'latitude','sw_fw'),assay_names,other_type)]
  
  filtered_df<-new.df

  #filter out with specified species
  if (missing(species_values)) filtered_df #returns everything in dataframe if argument is not specified
  else filtered_df<-filter(filtered_df, common_name %in% species_values)
 
  if (missing(years)) filtered_df #continue to update the filtered dataframe
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
    
  #dealing with chosen assays
  if (or_assay_filter==FALSE){  
      index<-0
      for (i in assay_names){ #loop through assays if or filter is false
        index<-index + 1
        filtered_df<-filter(filtered_df , filtered_df[assay_names[index]]<=CT_threshold[index])
      }
    } else{
      index<-1
      for (i in assay_names){
        if (length(assay_names)==1){ #no need to loop through if assay vector is length 1
          filtered_df<-filter(filtered_df,filtered_df[assay_names[1]]<=CT_threshold[1])
        } else{
          # loop through with or condition
          filtered_df<-filter(filtered_df,filtered_df[assay_names[index]]<=CT_threshold[index] | filtered_df[assay_names[index+1]]<=CT_threshold[index+1] )
          index<-index +1
          if (index + 1 > length(assay_names)){
            break
          
        }
        
        }
      }
    }
  
  
  
  #dealing with other filters

  
  index<-0
  for (i in other_type){
    index<-index + 1
    filtered_df<-filter(filtered_df , filtered_df[other_type[index]]==other_yn[index])
    }
  
  #filtered_df<-filtered_df
 
  
  
  print("summary statistics before removing N/A's")
  print(summary(filtered_df))
  View(filtered_df)
    
  #converting longitude and latitude to numeric values
  
  filtered_df$longitude<-as.numeric(filtered_df$longitude) 
  filtered_df$latitude<-as.numeric(filtered_df$latitude) 
  
  #getting rid of any NA's for longitude and latitude columns
  
  filtered_df<-filtered_df[!is.na(filtered_df$longitude),]
  filtered_df<-filtered_df[!is.na(filtered_df$latitude),]
  
  index1<-0
  for (i in assay_names){
    index1<-index1+1
    filtered_df<-filtered_df[!is.na(filtered_df[assay_names[index1]]),]
    
  }
  
  
  long<-filtered_df$longitude
  lat<-filtered_df$latitude
  #print(filtered_df)
  
  
  #create map
  if (missing(chosen_factor)){ #if there is no chosen factor use this map
    print("summary statistics after removing N/A's")
    print(summary(filtered_df))
    
    fish_map <- leaflet() %>%
      addProviderTiles(background_map) %>%  # use the default base map which is OpenStreetMap tiles
      addCircles(data= filtered_df,
                 lng= long, lat= lat,
                 radius = circle_size,
                 weight = circle_weight,
                 fillOpacity = circle_opacity,
                 popup = popup_name,
                 color = single_colour,
                 labelOptions(interactive=TRUE,
                              clickable=TRUE)
      )
    
    return(fish_map) #return map
    
  } else{
    filtered_df<-filtered_df[!is.na(filtered_df[chosen_factor]),]
    filtered_df[chosen_factor] <- lapply(filtered_df[chosen_factor], as.factor)
    
    print("summary statistics after removing N/A's")
    print(summary(filtered_df))
    
    pal <- colorFactor(palette = colour_palette , domain = filtered_df[,chosen_factor], reverse = F)
    
    
    #create map
    
    
    fish_map <- leaflet() %>%
      addProviderTiles(background_map) %>%  # use the default base map which is OpenStreetMap tiles
      addCircles(data= filtered_df,
                 lng= long, lat= lat,
                 radius = circle_size,
                 weight = circle_weight,
                 fillOpacity = circle_opacity,
                 popup = popup_name,
                 color = pal(filtered_df[,chosen_factor]),
                 labelOptions(interactive=TRUE,
                              clickable=TRUE)
      ) 
    fish_map %>%
      addLegend("bottomright", pal=pal, values=filtered_df[,chosen_factor],
                opacity = 1, title = legend_title)
   
    
  }
  
  }



