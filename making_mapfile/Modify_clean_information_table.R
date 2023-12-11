#################### Modify name of sample and clean table ####################

# install package 
install.packages("dplyr")


# Convert xlsx into csv file_fish
input_file <- "file_fish.xlsx"
output_file <- "file_fish.csv"
fish_data <- readxl::read_excel(here::here("making_mapfile",input_file))
write.csv(fish_data, file = (here::here("making_mapfile",output_file)), row.names = FALSE)
fish_data <- read.csv(here::here("making_mapfile","file_fish.csv"))

# Select only data with barcoding_id
fish_data <- fish_data[!is.na(fish_data$barcoding_id),]

# Convert xlsx into csv fieldsheet_food
input_file <- "file_food.xlsx"
output_file <- "file_food.csv"
food_data <- readxl::read_excel(here::here("making_mapfile",input_file))
write.csv(food_data, file = (here::here("making_mapfile",output_file)), row.names = FALSE)
food_data <- read.csv(here::here("making_mapfile","file_food.csv"))

# Delete 1st line of the df
food_data <- food_data[-1, ]

# Convert xlsx into csv file_water
input_file <- "file_water.xlsx"
output_file <- "file_water.csv"
water_data <- readxl::read_excel(here::here("making_mapfile",input_file))
write.csv(water_data, file = (here::here("making_mapfile",output_file)), row.names = FALSE)
water_data <- read.csv(here::here("making_mapfile","file_water.csv"))

# Delete 1st line of the df
water_data <- water_data[-1, ]

# Convert xlsx into csv file_sampling
input_file <- "file_sampling.xlsx"
output_file <- "file_sampling.csv"
sampling_data <- readxl::read_excel(here::here("making_mapfile",input_file))
write.csv(sampling_data, file = (here::here("making_mapfile",output_file)), row.names = FALSE)
sampling_data <- read.csv(here::here("making_mapfile","file_sampling.csv"))


# gather table vamaheat
vamaheat_data <- gtools::smartbind(fish_data, food_data, water_data, fill = NA)

# add sampling information 
vamaheat_data <- merge(vamaheat_data, sampling_data, by = c("sampling_id"), all.x = TRUE)


# Convert xlsx into csv metadata_fish_exofishmed
input_file <- "metadata_fish_exofishmed.xlsx"
output_file <- "metadata_fish_exofishmed.csv"
fish_exo <- readxl::read_excel(here::here("making_mapfile",input_file))
write.csv(fish_exo, file = (here::here("making_mapfile",output_file)), row.names = FALSE)
fish_exo <- read.csv(here::here("making_mapfile","metadata_fish_exofishmed.csv"))

# Modify name sampling id (add _exo) to differenciate from vamaheat sampling id
fish_exo$sampling_id <- paste(fish_exo$sampling_id, "_exo", sep = "")

# Modify name sample id into Sample ID
colnames(fish_exo)[1] <- "Sample_ID"

# Import metadata water and algae from exofishmed France and Grece
env_exo <- read.csv(here::here("making_mapfile","env_samples_selected.csv"))

# Modify name sampling id (add _exo) to differenciate from vamaheat sampling id
env_exo$sampling_id <- paste(env_exo$sampling_id, "_exo", sep = "")

# add barcoding_id column
env_exo$barcoding_id <- env_exo$Sample_ID
env_exo$barcoding_id <- paste(env_exo$barcoding_id, "_B", sep = "")

# gather table exofishmed
exofishmed_data <- gtools::smartbind(fish_exo, env_exo, fill = NA)


# Convertir la colonne 'body_mass' en classe 'character' si ce n'est pas déjà le cas
exofishmed_data$body_mass <- as.character(exofishmed_data$body_mass)
vamaheat_data$body_mass <- as.character(vamaheat_data$body_mass)

# gather table exofishmed and vamaheat
mapfile <- gtools::smartbind(exofishmed_data, vamaheat_data, fill = NA)

# List mock T- T+ to remove
colonnes_a_exclure <- c("mock1_1", "mock1_2", "mock2_1", "mock2_2", "mock3_1", "mock3_2", "T_1_1", "T_1_2", "T_2_1", "T_2_2")

# Remove list
asv_table <- asv_table[, -match(colonnes_a_exclure, names(asv_table))]

# Select only fish of interest
mapfile <- mapfile[mapfile$barcoding_id %in% names(asv_table),]  

# Change rownames
rownames(mapfile) <- mapfile$barcoding_id

# Export the file in the good folder with .txt format 
chemin_complet <- here::here("data","context", "mapfileFA.txt")
write.table(mapfile, file = chemin_complet, sep = "\t", row.names = TRUE)

# Export the file in the good folder in csv 
write.csv(mapfile, file = here::here("data","context", "mapfileFA.csv"), row.names = FALSE)





# Reorder and select only column of interest
#fish_data <- fish_data[c("gut_metabarcod_samples","sampling_id","Taxonomy","body_mass",
#"standard_length","body_width","mouth_depth","gut_fullness")]

# Select some lines of the table 
#fish_data <- fish_data[1:183,]  

# # Import metadata saupe from exofishmed France and Grece 
# saupes_exof <- read.csv(here::here("making_mapfile","sarpa_samples.csv"))
# # Modify name fish id into Sample ID
# colnames(saupes_exof)[2] <- "Sample_ID"
# # Modify name sampling id (add _exo) to differenciate from vamaheat sampling id 
# saupes_exof$sampling_id <- paste(saupes_exof$sampling_id, "_exo", sep = "")
# 
# # Import metadata saupe from exofishmed Grece 
# saupes_exof_grece <- read.csv(here::here("making_mapfile","table_metadata_saupes_crete.csv"))
# colnames(saupes_exof_grece)[3] <- "Sample_ID"
# # Modify name sampling id (add _exo) to differenciate from vamaheat sampling id 
# saupes_exof_grece$sampling_id <- paste(saupes_exof_grece$sampling_id, "_exo", sep = "")
# 
# # Merge saupe grece and saupe grece and france dataframe
# saupes_exof <- merge(saupes_exof_grece, saupes_exof, by = c("Sample_ID","region","season","sampling_id"), all = TRUE)

# # Install package tidyverse 
# install.packages("tidyverse")
# 
# # Charge package tidyverse
# library(tidyverse)
# 
# # Group lines with same Sample_ID
# saupes_exof <- saupes_exof %>%
#   group_by(Sample_ID) %>%
#   summarise_all(list)







# # Trouver les colonnes communes
# common_columns <- intersect(names(fish_data), names(food_data), names(water_data))
# 
# # Afficher les colonnes communes
# print(common_columns)

# #merge all the dataframe together
# merged_df <- merge(fish_data, sampling_data, by = c("sampling_id"), all.x = TRUE)
# 





