library(tibble)
library(dplyr)
library(lubridate)

## download data ##
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file <- "electricpowerconsumption.zip"
download.file(url, file, method= "curl")

## Uzip File
unzip("electricpowerconsumption.zip")

## Load files
hpc <- read.table("household_power_consumption.txt", sep = ";", header = TRUE)

## Conversion en tibble
hpc <- as.tibble(hpc)

## Subseting data
data <- rbind(subset(hpc, Date == "1/2/2007"), subset(hpc, Date == "2/2/2007"))
head(data)
rm(hpc)

# Itérer manuellement sur chaque colonne avec une boucle pour numériser
for (colonne in names(data[-c(1,2)])) {
        data <- data %>%
                mutate(!!colonne := as.numeric(.data[[colonne]])) %>% ## !!colonne pour s'assurer que le nom de la colonne 
                ##  est correctement évalué dans le contexte de la boucle
                suppressWarnings()
}   

## Adding a new col with Ftime 
data$Ftime<- paste(data$Date, data$Time, sep = " ")

## Select/arrange column that we are interest
data <- data %>% 
        select(Date, Time, Ftime, Global_active_power, Sub_metering_1,Sub_metering_2, Sub_metering_3, Voltage, Global_reactive_power )

## histogram of Global active power
png(filename = "Plot 1.png")
hist(data$Global_active_power, col = "red", xlab = "Globla Active Power (Kilowatts)", main = "Global Active Power")
dev.off()
