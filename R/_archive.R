bm_raster <- function(roi_sf,
                      product_id,
                      date,
                      bearer,
                      variable = NULL,
                      output_type = "raster", # raster, aggregation
                      output_location_type = "file", # r_memory, file
                      aggregation_fun = c("mean"),
                      file_dir = NULL,
                      file_prefix = NULL,
                      file_skip_if_exists = TRUE){
  
  # Checks ---------------------------------------------------------------------
  #if(nrow(roi_sf) > 1){
  #  stop("roi must be 1 row")
  #}
  
  if(!("sf" %in% class(roi_sf))){
    stop("roi must be an sf object")
  }
  
  # NTL Variable ---------------------------------------------------------------
  if(is.null(variable)){
    if(product_id == "VNP46A1") variable <- "DNB_At_Sensor_Radiance_500m"
    if(product_id == "VNP46A2") variable <- "Gap_Filled_DNB_BRDF-Corrected_NTL"
    if(product_id %in% c("VNP46A3", "VNP46A4")) variable <- "NearNadir_Composite_Snow_Free"
  }
  
  # Download data --------------------------------------------------------------
  r_list <- lapply(date, function(date_i){
    
    out <- tryCatch(
      {
        
        #### Make name for raster based on date
        if(product_id %in% c("VNP46A1", "VNP46A2")){
          date_name_i <- paste0("t", date_i %>% str_replace_all("-", "_"))
        }
        
        if(product_id %in% c("VNP46A3")){
          date_name_i <- paste0("t", date_i %>% str_replace_all("-", "_") %>% substring(1,7))
        }
        
        if(product_id %in% c("VNP46A4")){
          date_name_i <- paste0("t", date_i %>% str_replace_all("-", "_") %>% substring(1,4))
        }
        
        #### If save as tif format
        if(output_location_type == "file"){
          out_name <- paste0(file_prefix, product_id, "_", date_name_i, 
                             ifelse(output_type == "raster", 
                                    ".tif",
                                    ".Rds"))
          out_path <- file.path(file_dir, out_name)
          
          make_raster <- TRUE
          if(file_skip_if_exists & file.exists(out_path)) make_raster <- FALSE
          
          if(make_raster){
            
            r <- bm_raster_i(roi_sf = roi_sf,
                             product_id = product_id,
                             date = date_i,
                             bearer = bearer,
                             variable = variable)
            names(r) <- date_name_i
            
            if(output_type == "aggregation"){
              r_agg <- exact_extract(x = r, y = roi_sf, fun = aggregation_fun)
              roi_df <- roi_sf
              roi_df$geometry <- NULL
              
              if(length(aggregation_fun) > 1){
                names(r_agg) <- paste0("ntl_", names(r_agg))
                r_agg <- bind_cols(r_agg, roi_df)
              } else{
                roi_df$ntl <- r_out
                r_agg <- roi_df
              }
              r_agg$date <- date_i
              
              saveRDS(r_agg, out_path)
              
            } else{
              writeRaster(r, out_path)
            }
            
          } else{
            cat(paste0('"', out_path, '" already exists; skipping.'))
          }
          
          r_out <- NULL # Saving as tif file, so output from function should be NULL
          
        } else{
          r_out <- bm_raster_i(roi_sf = roi_sf,
                               product_id = product_id,
                               date = date_i,
                               bearer = bearer,
                               variable = variable)
          names(r_out) <- date_name_i
          
          if(output_type == "aggregation"){
            r_out <- exact_extract(x = r_out, y = roi_sf, fun = aggregation_fun)
            roi_df <- roi_sf
            roi_df$geometry <- NULL
            
            if(length(aggregation_fun) > 1){
              names(r_out) <- paste0("ntl_", names(r_out))
              r_out <- bind_cols(r_out, roi_df)
            } else{
              roi_df$ntl <- r_out
              r_out <- roi_df
            }
            r_out$date <- date_i
          }
        }
        
        return(r_out)
        
      },
      error=function(e) {
        return(NULL)
      }
    )
    
  })
  
  # Clean output ---------------------------------------------------------------
  # Remove NULLs
  r_list <- r_list[!sapply(r_list,is.null)]
  
  if(output_type == "aggregation"){
    r <- r_list %>%
      bind_rows()
  } else{
    
    if(length(r_list) == 1){
      r <- r_list[[1]]
    } else if (length(r_list) > 1){
      r <- raster::stack(r_list)
    } else{
      r <- NULL
    }
  }
  
  return(r)
}
