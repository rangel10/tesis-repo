% Optknock para mejores rutas de Saccharomyces cerevisiae 4OMET

% solver gurobi
changeCobraSolver('gurobi','all');
model = readCbModel('iMM904.mat');
biomass = 'BIOMASS_SC5_notrace';
threshold = 5;

% condiciones iniciales: -100 glucosa y -1000 oxigeno
model = changeRxnBounds(model, 'EX_glc__D_e',-100,'l');
model = changeRxnBounds(model,'EX_o2_e',-1000,'l');


