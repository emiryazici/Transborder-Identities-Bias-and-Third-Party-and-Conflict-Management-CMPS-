********************************************************************************
***Identity Bias Dataset
***Emir Yazici - 3/16/2017
********************************************************************************
*Create unique ID variable for each dyad
egen ID=group( numbera numberb)
*Create unique ID variable for each dyad-year 
egen ID=group( numbera numberb year)
*Drop 13 duplicate dyad-year obs
duplicates drop ID, force
*Rename Variables for Mediator-State A dyad
rename gslang gslang_ma
rename gsrelig gsrelig_ma
rename gsethnic gsethnic_ma
rename majminrelig majminrelig_ma
rename majminethnic majminethnic_ma
rename deplo deplo_ma
rename logdist logdist_ma
rename contig contig_ma
rename alliance alliance_ma

rename numbera potinta
rename numberb statea

*Rename Variables for Mediator-State B dyad
rename gslang gslang_mb
rename gsrelig gsrelig_mb
rename gsethnic gsethnic_mb
rename majminrelig majminrelig_mb
rename majminethnic majminethnic_mb
rename deplo deplo_mb
rename logdist logdist_mb
rename contig contig_mb
rename alliance alliance_mb

rename numbera potinta
rename numberb stateb


*Rename Variables for State A-Mediator dyad
rename gslang gslang_am
rename gsrelig gsrelig_am
rename gsethnic gsethnic_am
rename majminrelig majminrelig_am
rename majminethnic majminethnic_am
rename deplo deplo_am
rename logdist logdist_am
rename contig contig_am
rename alliance alliance_am

rename numbera statea
rename numberb potinta

*Rename Variables for State B-Mediator dyad
rename gslang gslang_bm
rename gsrelig gsrelig_bm
rename gsethnic gsethnic_bm
rename majminrelig majminrelig_bm
rename majminethnic majminethnic_bm
rename deplo deplo_bm
rename logdist logdist_bm
rename contig contig_bm
rename alliance alliance_bm


rename numbera stateb
rename numberb potinta
