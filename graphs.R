# Load Libraries
library(ggplot2)
library(dplyr)

# Paths
model_01_1d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-0101"
model_01_2d_path <-  "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-0101"
model_01_3d_path <-  "/home/tato/Documentos/GitHub/tesis-repo/optknock results/3D-0101"
model_nat_1d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-nat"
model_nat_2d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-nat"
model_nat_3d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/3D-nat"
model_07_1d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-0701"
model_07_2d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-0701"

model_01_1d_2_5_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-0101-2-5-MO"
model_01_1d_10_15_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-0101-10-15-MO"
model_01_1d_20_25_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-0101-20-25-MO"
model_01_2d_2_5_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-0101-2-5-MO"
model_01_2d_10_15_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-0101-10-15-MO"
model_01_2d_20_25_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-0101-20-25-MO"
model_01_3d_2_5_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/3D-0101-2-5-MO"
model_01_3d_10_15_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/3D-0101-10-15-MO"
model_01_3d_20_25_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/3D-0101-20-25-MO"

model_nat_1d_2_5_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-nat-2-5-MO"
model_nat_1d_10_15_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-nat-10-15-MO"
model_nat_1d_20_25_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-nat-20-25-MO"
model_nat_2d_2_5_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-nat-2-5-MO"
model_nat_2d_10_15_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-nat-10-15-MO"
model_nat_2d_20_25_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-nat-20-25-MO"
model_nat_3d_2_5_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/3D-nat-2-5-MO"
model_nat_3d_10_15_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/3D-nat-10-15-MO"
model_nat_3d_20_25_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/3D-nat-20-25-MO"

model_07_1d_2_5_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-0701-2-5-MO"
model_07_1d_10_15_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-0701-10-15-MO"
model_07_1d_20_25_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-0701-20-25-MO"
model_07_2d_2_5_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-0701-2-5-MO"
model_07_2d_10_15_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-0701-10-15-MO"
model_07_2d_20_25_MO_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-0701-20-25-MO"

# Biomass fluxes
bm_flux_01 <- 9.4526
bm_flux_nat <- 9.4266
bm_flux_07 <- 9.4396
bm_fluc_avg <- 9.4396

bmf_01_res <- c(bm_flux_01*0.1, bm_flux_01*0.2, bm_flux_01*0.3, bm_flux_01*0.4, bm_flux_01*0.5, bm_flux_01*0.6, bm_flux_01*0.7, bm_flux_01*0.8, bm_flux_01*0.9)
bmf_07_res <- c(bm_flux_07*0.1, bm_flux_07*0.2, bm_flux_07*0.3, bm_flux_07*0.4, bm_flux_07*0.5, bm_flux_07*0.6, bm_flux_07*0.7, bm_flux_07*0.8, bm_flux_07*0.9)
bmf_nat_res <- c(bm_flux_nat*0.1, bm_flux_nat*0.2, bm_flux_nat*0.3, bm_flux_nat*0.4, bm_flux_nat*0.5, bm_flux_nat*0.6, bm_flux_nat*0.7, bm_flux_nat*0.8, bm_flux_nat*0.9)

bmf_01_res3 <- c(bm_flux_01*0.3, bm_flux_01*0.5, bm_flux_01*0.8)
bmf_07_res3 <- c(bm_flux_07*0.3, bm_flux_07*0.5, bm_flux_07*0.8)
bmf_nat_res3 <- c(bm_flux_nat*0.3, bm_flux_nat*0.5, bm_flux_nat*0.8)


# Colors
# const_01_2 <- "#0E0091"
# const_01_5 <- "#0500FF"
# const_01_10 <- "#1670FF"
# const_01_15 <- "#00A3FC"
# const_01_20 <- "#24FAFF"
# const_01_25 <- "#A4FDFF"
# 
# const_nat_2 <- "#8E0000"
# const_nat_5 <- "#F80900"
# const_nat_10 <- "#FF523A"
# const_nat_15 <- "#FF826A"
# const_nat_20 <- "#FFBFAB"
# const_nat_25 <- "#FFDAD3"
# 
# const_07_2 <- "#0B6E00"
# const_07_5 <- "#16B500"
# const_07_10 <- "#0EFF01"
# const_07_15 <- "#76FF76"
# const_07_20 <- "#A5FF98"
# const_07_25 <- "#D1FFD4"

# Functions
extract_value <- function(s) {
  str_value <- regmatches(s,gregexpr("\\d+\\.*\\d*",s))
  value <- as.numeric(str_value)
  return(value)
}

get_frequencies <- function(df_data) {
  df_freq <- data.frame(Reaction=character(), Frequency=numeric())
  for (rxns in df_data$Reaction) {
    rxns_vec <- unlist(strsplit(rxns, split=" "))
    for (rxn in rxns_vec) {
      exist <- length(df_freq[df_freq$Reaction==rxn,"Frequency"])
      if (exist) {
        df_freq[df_freq$Reaction==rxn,"Frequency"] <- df_freq[df_freq$Reaction==rxn,"Frequency"] + 1
      } else {
        df_freq[nrow(df_freq) + 1,] <- list(rxn, 1)
      }
    }
  }
  return(df_freq)
}

read_files <- function(path, bm_base) {
  objs <- numeric()
  biomass <- numeric()
  df_data <- data.frame(Reaction=character(), Objs=numeric(), Biomass=numeric())
  files_list <- list.files(path)
  for (f in files_list) {
    full_path <- paste(path, f, sep = "/")
    con <- file(full_path, open = 'r',encoding = "UTF-8")
    lines <- readLines(con)
    for (line in lines) {
      if (startsWith(line, "Rxns")) {
        s <- trimws(line)
        df_data[nrow(df_data)+1, "Reaction"] <- substr(s, 7, nchar(s))
      } else if (startsWith(line, "Obj")) {
        value <- extract_value(line)
        df_data[nrow(df_data), "Objs"] <- value
      } else if (startsWith(line, "Biomass")) {
        value <- extract_value(line)
        value <- value/bm_base*100
        df_data[nrow(df_data), "Biomass"] <- value
      }
    }
    close(con)
  }
  return(df_data)
}

# Data
data_01 <- read_files(model_01_2d_path, bm_flux_01)
data_nat <- read_files(model_nat_2d_path, bm_flux_nat)
data_07 <- read_files(model_07_2d_path, bm_flux_07)

objs_01 <- data_01$Objs
biomass_01 <- data_01$Biomass

objs_nat <- data_nat$Objs
biomass_nat <- data_nat$Biomass

objs_07 <- data_07$Objs
biomass_07 <- data_07$Biomass

# Filtered data
df_01_low_objs <- subset(data_01, Objs < 10)
df_01_mod_objs <- subset(data_01, Objs >= 10 & Objs < 20)
df_01_hig_objs <- subset(data_01, Objs >= 20)

df_nat_low_objs <- subset(data_nat, Objs < 10)
df_nat_mod_objs <- subset(data_nat, Objs >= 10 & Objs < 20)
df_nat_hig_objs <- subset(data_nat, Objs >= 20)

df_07_low_objs <- subset(data_07, Objs < 10)
df_07_mod_objs <- subset(data_07, Objs >= 10 & Objs < 20)
df_07_hig_objs <- subset(data_07, Objs >= 20)

df_01_low_bm <- subset(data_01, Biomass < bm_flux_01*0.3)
df_01_mod_bm <- subset(data_01, Biomass >= bm_flux_01*0.3 & Biomass < bm_flux_01*0.7)
df_01_hig_bm <- subset(data_01, Biomass >= bm_flux_01*0.7)

df_nat_low_bm <- subset(data_nat, Biomass < bm_flux_nat*0.3)
df_nat_mod_bm <- subset(data_nat, Biomass >= bm_flux_nat*0.3 & Biomass < bm_flux_nat*0.7)
df_nat_hig_bm <- subset(data_nat, Biomass >= bm_flux_nat*0.7)

df_07_low_bm <- subset(data_07, Biomass < bm_flux_07*0.3)
df_07_mod_bm <- subset(data_07, Biomass >= bm_flux_07*0.3 & Biomass < bm_flux_07*0.7)
df_07_hig_bm <- subset(data_07, Biomass >= bm_flux_07*0.7)

# Apply filters

# Top ranked
rxns_01_low <- get_frequencies(df_01_low_objs)
rxns_01_mod <- get_frequencies(df_01_mod_objs)
rxns_01_hig <- get_frequencies(df_01_hig_objs)

rxns_07_low <- get_frequencies(df_07_low_objs)
rxns_07_mod <- get_frequencies(df_07_mod_objs)
rxns_07_hig <- get_frequencies(df_07_hig_objs)

rxns_nat_low <- get_frequencies(df_nat_low_objs)
rxns_nat_mod <- get_frequencies(df_nat_mod_objs)
rxns_nat_hig <- get_frequencies(df_nat_hig_objs)

rxns_01_low.top10 <- rxns_01_low[order(rxns_01_low$Frequency, decreasing=TRUE),][1:10,]
rxns_01_mod.top10 <- rxns_01_mod[order(rxns_01_mod$Frequency, decreasing=TRUE),][1:10,]
rxns_01_hig.top10 <- rxns_01_hig[order(rxns_01_hig$Frequency, decreasing=TRUE),][1:10,]

rxns_07_low.top10 <- rxns_07_low[order(rxns_07_low$Frequency, decreasing=TRUE),][1:10,]
rxns_07_mod.top10 <- rxns_07_mod[order(rxns_07_mod$Frequency, decreasing=TRUE),][1:10,]
rxns_07_hig.top10 <- rxns_07_hig[order(rxns_07_hig$Frequency, decreasing=TRUE),][1:10,]

rxns_nat_low.top10 <- rxns_nat_low[order(rxns_nat_low$Frequency, decreasing=TRUE),][1:10,]
rxns_nat_mod.top10 <- rxns_nat_mod[order(rxns_nat_mod$Frequency, decreasing=TRUE),][1:10,]
rxns_nat_hig.top10 <- rxns_nat_hig[order(rxns_nat_hig$Frequency, decreasing=TRUE),][1:10,]

lowCategory <- sample('Low',10,replace=TRUE)
modCategory <- sample('Moderate',10,replace=TRUE)
higCategory <- sample('High',10,replace=TRUE)

rxns_01_low.top10$Category <- lowCategory
rxns_01_mod.top10$Category <- modCategory
rxns_01_hig.top10$Category <- higCategory

rxns_07_low.top10$Category <- lowCategory
rxns_07_mod.top10$Category <- modCategory
rxns_07_hig.top10$Category <- higCategory

rxns_nat_low.top10$Category <- lowCategory
rxns_nat_mod.top10$Category <- modCategory
rxns_nat_hig.top10$Category <- higCategory

# Linear Regression
# formula <- Biomass~Objs
# lm_01 <- lm(formula, data_01)
# lm_nat <- lm(formula, data_nat)
# lm_07 <- lm(formula, data_07)
# R2_01 <- paste0("01_1  R² = ", signif(summary(lm_01)$r.squared, digits=4))
# R2_nat <- paste0("NAT   R² = ", signif(summary(lm_nat)$r.squared, digits=4))
# R2_07 <- paste0("07_1  R² = ", signif(summary(lm_07)$r.squared, digits=4))

# Plot
# plot( x=0, main = "4OMET flux by Biomass flux percentage with 3 knockouts", xlab = "4OMET flux (mmol/gDW*hr)",
#      ylab = "Biomass flux %", xlim = c(2,26), ylim = c(0,100), cex.main=2, cex.lab=1.4, cex.axis=1.3)
# abline(v=c(2,5,10,15,20,25), col="#54e8ff", lty=3,lwd=2)  
# abline(h=c(30,50,80), col="#54e8ff", lty=3, lwd=2)
# points( data_01$Objs, data_01$Biomass,  col="blue", pch=20, cex=1.5)
# #points( data_07$Objs, data_07$Biomass,  col="darkgreen", pch=20, cex=1.5)
# points( data_nat$Objs,data_nat$Biomass,  col="red",pch=20, cex = 1.5)
# axis(side=2,at=seq(10,100,10))
# axis(side=1,at=c(2,5,10,15,20,25), cex.axis=1.3)
# abline(lm_01, col="blue", lwd=2)
# text(23, 6, R2_01, col="blue", cex=1.25)
# abline(lm_nat, col="red", lwd=2)
# text(23, 5, R2_nat, col="red", cex=1.25)
# abline(lm_07, col="darkgreen", lwd=2)
# text(23, 4, R2_07, col="darkgreen", cex=1.25)

# abline(h=bmf_01_res, col="#34b7eb", lty=3,lwd=2)
# abline(h=bmf_nat_res, col="#9649cc", lty=3,lwd=2)
# abline(h=bmf_07_res, col="#a6a43c", lty=3,lwd=2)

# 2 and 1 deletions
# legend("topright", legend = c("01_1","NAT"), pch = c(20,20,20),
#      col=c("blue","red"), cex=1.5, lty=c(-1,-1,-1), ncol=1, lwd=2)

# 3 deletions
# legend("topright", legend = c("01_1","NAT","01_1","NAT"), pch = c(20,20,-1,-1),
#        col=c("blue","red","blue","red"), cex=1.5, lty=c(-1,-1,1,1), ncol=2, lwd=2)

# Frequency
# barplot(rxns_nat.top10$Frequency, names.arg = rxns_nat.top10$Reaction, xlab = "Reactions", ylab = "Frequency", col = "chartreuse3",
#         main = "Most frequent knockouts in low objective flux for NAT",
#         cex.main=2, cex.lab=1.4, cex.axis=1.3)

categories <- c('Low', 'High','Moderate')

# Merges
rxns_01.top10 <- merge(rxns_01_hig.top10, rxns_01_low.top10, all=TRUE)
rxns_01.top10 <- merge(rxns_01.top10, rxns_01_mod.top10, all=TRUE)

rxns_07.top10 <- merge(rxns_07_hig.top10, rxns_07_low.top10, all=TRUE)
rxns_07.top10 <- merge(rxns_07.top10, rxns_07_mod.top10, all=TRUE)

rxns_nat.top10 <- merge(rxns_nat_hig.top10, rxns_nat_low.top10, all=TRUE)
rxns_nat.top10 <- merge(rxns_nat.top10, rxns_nat_mod.top10, all=TRUE)

formula_01 <- rxns_01.top10$Frequency ~ rxns_01.top10$Category
formula_07 <- rxns_07.top10$Frequency ~ rxns_07.top10$Category
formula_nat <- rxns_nat.top10$Frequency ~ rxns_nat.top10$Category

stripchart(formula_01, pch=18, method='stack', jitter=0.3, vertical=TRUE, col=c('red','darkgreen','blue'), ylab='Frequency', main='Most frequent knockouts in 01_1',
           cex.main=2, cex.lab=1.4, cex.axis=1.3, cex=1.5)

