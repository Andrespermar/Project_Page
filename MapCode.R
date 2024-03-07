#Install packages and load libraries
library(plotly)
library(devtools)
library(DomoR)


#Load data
df = read.csv("C:/Users/User/Documents/Working Directory/MPC Thinning (Renovans).csv")

domo = rdomo::Domo('94af109b-7e1f-4f59-9b8c-576abfbc3b5c','4fa65d787381d78e860c08c14bd3703b846020d59be460d5e2ed4b8f946d523c')
SOI_v1 = domo$ds_get("a9557991-439f-4533-a761-a0c801a36dad")


#Dataset contains various 0s so we get rid of those rows
df = df %>%
  filter(longitude != 0)

df = df %>%
  filter(latitude != 0)



#Filter so we only get 2023 and 2024 observations
# Convert the date column to Date type
df$date = as.Date(df$date)

df$year = as.numeric(format(df$date, "%Y"))

# Extract the year from the date and filter
df = subset(df, format(date, "%Y") %in% c("2023", "2024"))


#Create new variable with desired hovertext
df$hovertext = paste("Count: ", df$count, "<br>Date: ", as.character(df$date), sep="")

# Create a new column for colors based on the year
df$color = ifelse(df$year == 2023, "blue", ifelse(df$year == 2024, "red", NA))


#Plot the points in a map
fig = df 
fig = fig %>%
  plot_ly(
    lat = ~latitude,
    lon = ~longitude,
    marker = list(color = ~color),
    type = 'scattermapbox',
    hovertext = df[,"hovertext"])

fig = fig %>%
  layout(mapbox= list(
    style = "white-bg",
    zoom = 3,
    center = list(lon = -93 ,lat= 41),
    layers = list(list(
      below = 'traces',
      sourcetype = "raster",
      source = list("https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}")))))


fig













