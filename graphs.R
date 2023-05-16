
model_01_1d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-0101"

model_01_2d_path <-  "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-0101"

model_nat_1d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/1D-nat"

model_nat_2d_path <- "/home/tato/Documentos/GitHub/tesis-repo/optknock results/2D-nat"

files_01_1d <- list.files(model_01_1d_path)

files_01_2d <- list.files(model_01_2d_path)

files_nat_1d <- list.files(model_nat_1d_path)

files_nat_2d <- list.files(model_nat_2d_path)

objs_01 <- numeric()
biomass_01 <- numeric()
objs_nat <- numeric()
biomass_nat <- numeric()

bm_flux_01 <- 9.4526
bm_flux_nat <- 9.4266

extract_value <- function(s) {
  str_value <- regmatches(s,gregexpr("\\d+\\.*\\d*",s))
  value <- as.numeric(str_value)
  return(value)
}

for (f in files_01_1d) {
  filename <- paste(model_01_1d_path, f, sep = "/")
  con <- file(filename, open = 'r',encoding = "UTF-8")
  lines <- readLines(con)
  for (line in lines) {
    if (startsWith(line, "Obj")) {
      value <- extract_value(line)
      objs_01 <- append(objs_01, value)
    } else if (startsWith(line, "Biomass")) {
      value <- extract_value(line)
      biomass_01 <- append(biomass_01, value)
    }
  }
  close(con)
}

for (f in files_nat_1d) {
  filename <- paste(model_nat_1d_path, f, sep = "/")
  con <- file(filename, open = 'r',encoding = "UTF-8")
  lines <- readLines(con)
  for (line in lines) {
    if (startsWith(line, "Obj")) {
      value <- extract_value(line)
      objs_nat <- append(objs_nat, value)
    } else if (startsWith(line, "Biomass")) {
      value <- extract_value(line)
      biomass_nat <- append(biomass_nat, value)
    }
  }
  close(con)
}

percent_01 <- function(x){ x/bm_flux_01*100}
percent_nat <- function(x){ x/bm_flux_nat*100}
biomass_01 <- lapply(biomass_01, percent_01)
biomass_nat <- lapply(biomass_nat, percent_nat)
plot(objs_01,biomass_01,main = "4'-O-methylnorbelladine fluxes by biomass percentage with 1 knockout", xlab = "4'-O-methylnorbelladine flux",
     ylab = "Biomass %", pch=17, col="blue", cex = 1.15 )
points(objs_nat, biomass_nat, col="red",pch=19, cex = 1.15)
legend("topright", legend = c("01_01","NAT"), pch = c(17,19), col=c("blue","red"), cex = 2, horiz = TRUE)