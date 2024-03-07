#Install packages and load libraries
library(plotly)
library(htmlwidgets)


#Load data
#df = read.csv("C:/Users/User/Documents/Working Directory/MPC Thinning (Renovans).csv")
domo = rdomo::Domo('94af109b-7e1f-4f59-9b8c-576abfbc3b5c','4fa65d787381d78e860c08c14bd3703b846020d59be460d5e2ed4b8f946d523c')

df = domo$ds_get("e32eabaf-c1c0-43cc-bb66-ba3d4662ee3a")


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
df$hovertext = paste("Commodity: ", df$commodity, 
                     "<br>Variety: ", df$variety,
                     "<br>Block ID: ", df$blockid,
                     "<br>Count: ", df$count, 
                     "<br>Date: ", as.character(df$date), sep="")

# Create a new column for colors based on the year
df$color = ifelse(df$year == 2023, "blue", ifelse(df$year == 2024, "red", ifelse(df$year == 2022, "yellow", ifelse(df$year == 2021, "green", ifelse(df$year == 2020, "white", ifelse(df$year == 2019, "purple", ifelse(df$year == 2018, "black", NA)))))))


#Plot the points in a map
fig = df 
fig = fig %>%
  plot_ly(
    lat = ~latitude,
    lon = ~longitude,
    marker = list(color = ~color),
    type = 'scattermapbox',
    hovertext = ~hovertext,
    hoverinfo = 'text')

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




library(htmlwidgets)

# Assuming 'fig' is your Plotly plot object
saveWidget(fig, file="C:/Users/User/Documents/R Scripts/InteractiveMaps/Map4.html")






#df = subset(df, format(date, "%Y") %in% c("2023", "2024"))



