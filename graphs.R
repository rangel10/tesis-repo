# Load Libraries
# library(dplyr)

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
        df_data[nrow(df_data), "Biomass"] <- value
      }
    }
    close(con)
  }
  #biomass <- lapply(biomass, function(x){x/bm_base*100})
  return(df_data)
}

# Data
data_01 <- read_files(model_01_3d_path, bm_flux_01)
data_nat <- read_files(model_nat_3d_path, bm_flux_nat)
data_07 <- read_files(model_07_2d_path, bm_flux_07)

objs_01 <- data_01$Objs
biomass_01 <- data_01$Biomass

objs_nat <- data_nat$Objs
biomass_nat <- data_nat$Biomass

objs_07 <- data_07$Objs
biomass_07 <- data_07$Biomass

# Filtered data
df_01_low_objs <- subset(data_01, Objs < 10)
df_01_med_objs <- subset(data_01, Objs >= 10 & Objs < 20)
df_01_hig_objs <- subset(data_01, Objs >= 20)

df_nat_low_objs <- subset(data_nat, Objs < 10)
df_nat_med_objs <- subset(data_nat, Objs >= 10 & Objs < 20)
df_nat_hig_objs <- subset(data_nat, Objs >= 20)

df_07_low_objs <- subset(data_07, Objs < 10)
df_07_med_objs <- subset(data_07, Objs >= 10 & Objs < 20)
df_07_hig_objs <- subset(data_07, Objs >= 20)

df_01_low_bm <- subset(data_01, Biomass < bm_flux_01*0.3)
df_01_med_bm <- subset(data_01, Biomass >= bm_flux_01*0.3 & Biomass < bm_flux_01*0.7)
df_01_hig_bm <- subset(data_01, Biomass >= bm_flux_01*0.7)

df_nat_low_bm <- subset(data_nat, Biomass < bm_flux_nat*0.3)
df_nat_med_bm <- subset(data_nat, Biomass >= bm_flux_nat*0.3 & Biomass < bm_flux_nat*0.7)
df_nat_hig_bm <- subset(data_nat, Biomass >= bm_flux_nat*0.7)

df_07_low_bm <- subset(data_07, Biomass < bm_flux_07*0.3)
df_07_med_bm <- subset(data_07, Biomass >= bm_flux_07*0.3 & Biomass < bm_flux_07*0.7)
df_07_hig_bm <- subset(data_07, Biomass >= bm_flux_07*0.7)

# Apply filters
data_01 <- df_01_hig_objs
data_nat <- df_nat_hig_bm
data_07 <- df_07_hig_bm

# Top ranked
rxns_01 <- get_frequencies(data_01)
rxns_nat <- get_frequencies(data_nat)
rxns_07 <- get_frequencies(data_07)

rxns_01.top10 <- rxns_01[order(rxns_01$Frequency, decreasing=TRUE),][1:10,]
rxns_nat.top10 <- rxns_nat[order(rxns_nat$Frequency, decreasing=TRUE),][1:10,]
rxns_07.top10 <- rxns_07[order(rxns_07$Frequency, decreasing=TRUE),][1:10,]

# Linear Regression
formula <- Objs~Biomass
# lm_01 <- lm(formula, data_01)
# lm_nat <- lm(formula, data_nat)
# lm_07 <- lm(formula, data_07)
# R2_01 <- paste0("01_1  R² = ", signif(summary(lm_01)$r.squared, digits=4))
# R2_nat <- paste0("NAT   R² = ", signif(summary(lm_nat)$r.squared, digits=4))
# R2_07 <- paste0("07_1  R² = ", signif(summary(lm_07)$r.squared, digits=4))

# Plot
# plot( data_01$Biomass, data_01$Objs, main = "Biomass flux by 4'-O-methylnorbelladine flux with 3 knockouts", ylab = "4'-O-methylnorbelladine flux",
#      xlab = "Biomass flux", pch=20, col="blue", cex = 1.25, ylim = c(2,26), xlim = c(0,10))
# points( data_nat$Biomass, data_nat$Objs, col="red",pch=20, cex = 1.25)
# points( data_07$Objs, data_07$Biomass,  col="darkgreen", pch=20, cex=1.25)
# # axis(side=2,at=seq(10,100,10))
# # axis(side=1,at=c(2,5,10,15,20,25))
# abline(lm_01, col="blue", lwd=2)
# text(9, 15, R2_01, col="blue", cex=1)
# abline(lm_nat, col="red", lwd=2)
# text(9, 14, R2_nat, col="red", cex=1)
# abline(lm_07, col="darkgreen", lwd=2)
# text(23, 5, R2_07, col="darkgreen", cex=1)

# 2 and 1 deletions
# legend("topright", legend = c("01_1","NAT","07_1","01_1","NAT","07_1"), pch = c(20,20,20,-1,-1,-1),
#      col=c("blue","red","darkgreen","blue","red","darkgreen"), cex=1.25, lty=c(-1,-1,-1,1,1,1), ncol=2, lwd=2)

# 3 deletions
# legend("topright", legend = c("01_1","NAT","01_1","NAT"), pch = c(20,20,-1,-1),
#        col=c("blue","red","blue","red"), cex=1.25, lty=c(-1,-1,1,1), ncol=2, lwd=2)

# Frequency
barplot(rxns_07.top10$Frequency, names.arg = rxns_07.top10$Reaction, xlab = "Reactions", ylab = "Frequency", col = "chartreuse3",
        main = "Most frequent reactions knocked out in pathway 07_1 with 2 deletions constraint")