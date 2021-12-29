# the structure of private data remains the same

    Code
      class(full())
    Output
      [1] "tbl_df"     "tbl"        "data.frame"

---

    Code
      names(full())
    Output
       [1] "rowid"                   "technology"             
       [3] "target_company_id"       "subsidiary_company_id"  
       [5] "target_company_name"     "subsidiary_company_name"
       [7] "SBTI"                    "CA100"                  
       [9] "market_cap"              "company_status"         
      [11] "state_owned_entity_type" "shares_weight"          
      [13] "source_id"               "asset_name"             
      [15] "start_year"              "dual"                   
      [17] "status_x"                "asset_location"         
      [19] "comp_cap_2018q4"         "comp_cap_2018_actual"   
      [21] "comp_cap_2018_plan"      "status_y"               
      [23] "comp_cap_2020q3"         "comp_cap_2020_actual"   
      [25] "source_id_cnt"           "category"               
      [27] "asset_cap_2018q4"        "asset_cap_2020q3"       
      [29] "region"                  "sub-region"             
      [31] "comp_size"               "comp_region"            
      [33] "comp_sub_region"         "target_company"         
      [35] "subsidiary_company"     

---

    Code
      dim(full())
    Output
      [1] 162116     35

