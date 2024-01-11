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

## Adding a new col with Ftime and mutate it to date class
data$Ftime<- paste(data$Date, data$Time, sep = " ")
data <- data %>%
        mutate(Ftime = strptime(Ftime, format = "%d/%m/%Y %H:%M:%S"))

## Select/arrange column that we are interest
data <- data %>% 
        select(Date, Time, Ftime, Global_active_power, Sub_metering_1,Sub_metering_2, Sub_metering_3, Voltage, Global_reactive_power )

## plot Time with global active power
png(filename = "Plot 2.png")

with(data, plot(Ftime, Global_active_power, type ="l",xaxt = "n" ,xlab = " ", ylab="Global Active Power (kilowatts)"))
## x- axis units
axis_unit <- strptime(c("2007-02-01 00:00:00", "2007-02-02 00:00:00", "2007-02-03 00:00:00"),format = "%Y-%m-%d %H:%M:%S")
axis_unit <- as.POSIXct(axis_unit)
axis(1, at = axis_unit , labels = format(axis_unit, format = "%a"))

dev.off()
