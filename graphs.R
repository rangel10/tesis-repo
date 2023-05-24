
# Paths
model_01_1d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-0101"
model_01_2d_path <-  "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-0101"
model_01_3d_path <-  "/home/tato/Documentos/GitHub/tesis-repo/optknock results/3D-0101"
model_nat_1d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-nat"
model_nat_2d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-nat"
model_nat_3d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/3D-nat"
model_07_1d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-0701"
model_07_2d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-0701"

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

read_files <- function(path, bm_base) {
  objs <- numeric()
  biomass <- numeric()
  df <- data.frame(Reaction=character(), Frequency=numeric())
  files_list <- list.files(path)
  for (f in files_list) {
    full_path <- paste(path, f, sep = "/")
    con <- file(full_path, open = 'r',encoding = "UTF-8")
    lines <- readLines(con)
    for (line in lines) {
      if (startsWith(line, "Rxns")) {
        s = trimws(line)
        rxns <- unlist(strsplit(s, split=" "))
        for (rxn in rxns[2:length(rxns)]) {
          exist <- length(df[df$Reaction==rxn,"Frequency"])
          if (exist) {
            df[df$Reaction==rxn,"Frequency"] <- df[df$Reaction==rxn,"Frequency"] + 1
          } else {
            df[nrow(df) + 1,] <- list(rxn, 1)
          }
        }
      } else if (startsWith(line, "Obj")) {
        value <- extract_value(line)
        objs <- append(objs, value)
      } else if (startsWith(line, "Biomass")) {
        value <- extract_value(line)
        biomass <- append(biomass, value)
      }
    }
    close(con)
  }
  biomass <- lapply(biomass, function(x){x/bm_base*100})
  return(list(objs, biomass, df))
}

# Data
data_01 <- read_files(model_01_3d_path, bm_flux_01)
data_nat <- read_files(model_nat_3d_path, bm_flux_nat)
data_07 <- read_files(model_07_2d_path, bm_flux_07)

objs_01 <- data_01[1][[1]]
biomass_01 <- unlist(data_01[2])
rxns_01 <- data_01[3][[1]]

objs_nat <- data_nat[1][[1]]
biomass_nat <- unlist(data_nat[2])
rxns_nat <- data_nat[3][[1]]

objs_07 <- data_07[1][[1]]
biomass_07 <- unlist(data_07[2])
rxns_07 <- data_07[3][[1]]

# Top ranked
rxns_01.top10 <- rxns_01[order(rxns_01$Frequency, decreasing=TRUE),][1:10,]
rxns_nat.top10 <- rxns_nat[order(rxns_nat$Frequency, decreasing=TRUE),][1:10,]
rxns_07.top10 <- rxns_07[order(rxns_07$Frequency, decreasing=TRUE),][1:10,]

# Linear Regression
df_01 <- data.frame(objs_01, biomass_01)
df_nat <- data.frame(objs_nat, biomass_nat)
df_07 <- data.frame(objs_07, biomass_07)
lm_01 <- lm(biomass_01~objs_01, df_01)
lm_nat <- lm(biomass_nat~objs_nat, df_nat)
lm_07 <- lm(biomass_07~objs_07, df_07)
R2_01 <- paste0("01_1  R² = ", signif(summary(lm_01)$r.squared, digits=3))
R2_nat <- paste0("NAT   R² = ", signif(summary(lm_nat)$r.squared, digits=3))
R2_07 <- paste0("07_1  R² = ", signif(summary(lm_07)$r.squared, digits=3))

# Plot
# plot(objs_01, biomass_01, main = "4'-O-methylnorbelladine fluxes by biomass percentage with 3 knockouts", xlab = "4'-O-methylnorbelladine flux",
#      ylab = "Biomass %", pch=20, col="blue", cex = 1.25, xlim = c(2,26), ylim = c(10,100))
# points(objs_nat, biomass_nat, col="red",pch=20, cex = 1.25)
# points(objs_07, biomass_07, col="darkgreen", pch=20, cex=1.25)
# axis(side=2,at=seq(10,100,10))
# axis(side=1,at=c(2,5,10,15,20,25))
# abline(lm_01, col="blue", lwd=2)
# text(23, 70, R2_01, col="blue", cex=1)
# abline(lm_nat, col="red", lwd=2)
# text(23, 65, R2_nat, col="red", cex=1)
# abline(lm_07, col="darkgreen", lwd=2)
# text(23, 60, R2_07, col="darkgreen", cex=1)

# 2 deletions
# legend("topright", legend = c("01_1","NAT","07_1","01_1","NAT","07_1"), pch = c(20,20,20,-1,-1,-1),
#      col=c("blue","red","darkgreen","blue","red","darkgreen"), cex=1.25, lty=c(-1,-1,-1,1,1,1), ncol=2, lwd=2)

# 3 deletions
# legend("topright", legend = c("01_1","NAT","01_1","NAT"), pch = c(20,20,-1,-1), 
#        col=c("blue","red","blue","red"), cex=1.25, lty=c(-1,-1,1,1), ncol=2, lwd=2)

# Frequency
barplot(rxns_01.top10$Frequency, names.arg = rxns_01.top10$Reaction, xlab = "Reactions", ylab = "Frequency", col = "chartreuse3", 
        main = "Most frequent reactions knocked out in pathway 01_1 with 3 deletions constraint")