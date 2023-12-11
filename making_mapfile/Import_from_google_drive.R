# import file from Google drive


#install.packages("googledrive")
#library(googledrive)

googledrive::drive_auth()

#files <- drive_ls()

# Define the link of the file 
file_fish <- "https://docs.google.com/spreadsheets/d/19Wd6nfhK8Icx1YcX9zb18zm04AkuCaXAUjHA-W83z7k/edit?usp=drive_link"
file_sampling <- "https://docs.google.com/spreadsheets/d/1kDba_qiefEokq0uY_lpZQibj7kvSNa1GE9zrjroahgE/edit?usp=drive_link"
file_water <- "https://docs.google.com/spreadsheets/d/1ye7RoxONwX4yY1tir80jf1pAqf6GJlaF/edit?usp=drive_link&ouid=102412727593159633340&rtpof=true&sd=true"
file_food <- "https://docs.google.com/spreadsheets/d/1Te2LS9JY89E78eHC0CWZHdA2rA0Ft_l6/edit?usp=drive_link&ouid=102412727593159633340&rtpof=true&sd=true"
  
# Download the file 
file <- googledrive::drive_download(file = file_fish, path = (here::here("making_mapfile", "file_fish.xlsx")), overwrite = TRUE)
file <- googledrive::drive_download(file = file_sampling, path = (here::here("making_mapfile","file_sampling.xlsx")), overwrite = TRUE)
file <- googledrive::drive_download(file = file_water, path = (here::here("making_mapfile","file_water.xlsx")), overwrite = TRUE)
file <- googledrive::drive_download(file = file_food, path = (here::here("making_mapfile","file_food.xlsx")), overwrite = TRUE)
