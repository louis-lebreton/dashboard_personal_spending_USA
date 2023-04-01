# Transformation des données

# Repertoire
setwd(dir='E:/Projet_PowerBI')

# Packages 
library(tidyr)
library(lubridate)

# IPC 2015 pour chaque année
IPC2015 <- read.csv("IPC_USA_2015.csv")
sum(is.na(IPC2015))

IPC2015$DATE <- ymd(as.character(IPC2015$DATE))
IPC2015$DATE <- as.integer(format(IPC2015$DATE,"%Y"))
v_ipc <- as.vector(tapply(IPC2015$USACPIALLMINMEI,IPC2015$DATE,mean))
v_ipc <- tail(list_ipc, 25)

## Pour le dataframe en dollars
dfg<- read.csv("data_1_1997_2021.csv")
sum(is.na(dfg))

add <- c(rep(NA,3),rep("Durable goods",4),NA,rep("Nondurable goods",4),NA,NA,rep("Services",8),NA,NA)
dfg$IndustryClassification <- c(rep(add,60),rep(NA,4))
colnames(dfg)[2]  <- "State"
colnames(dfg)[6]  <- "Type"

df <- dfg[is.na(dfg$Type)==FALSE,]
colnames(df)[9:33] <- 1997:2021

df <- df %>% 
  pivot_longer(
    cols = '1997':'2021', 
    names_to = "Year",
    values_to = "Value"
  )

# Conversion dollars courant > dollars constant 2015
df$IPC <-rep(v_ipc,960)
df$Value <- (df$Value/df$IPC) * 100

write.csv(df,"data_1_1997_2021_transforme.csv", row.names = FALSE)

## Pour le dataframe en dollars par habitant
dfg<- read.csv("data_1_par_hab_1997_2021.csv")
sum(is.na(dfg))

add <- c(rep(NA,3),rep("Durable goods",4),NA,rep("Nondurable goods",4),NA,NA,rep("Services",8),NA,NA)
dfg$IndustryClassification <- c(rep(add,60),rep(NA,4))
colnames(dfg)[2]  <- "State"
colnames(dfg)[6]  <- "Type"

df <- dfg[is.na(dfg$Type)==FALSE,]
colnames(df)[9:33] <- 1997:2021

df <- df %>% 
  pivot_longer(
    cols = '1997':'2021', 
    names_to = "Year",
    values_to = "Value"
  )

# Conversion dollars courant > dollars constant 2015
df$IPC <-rep(v_ipc,960)
df$Value <- (df$Value/df$IPC) * 100

write.csv(df,"data_1_par_hab_1997_2021_transforme.csv", row.names = FALSE)