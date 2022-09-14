
data_lookup<-function(){


  #load from db
 # removed for privacy


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


  #view
  View(all.df)



}


