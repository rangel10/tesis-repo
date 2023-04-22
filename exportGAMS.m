% solver gurobi
changeCobraSolver('gurobi','all');

% modelo base
model_b = readCbModel('iMM904.mat');
biomass = 'BIOMASS_SC5_notrace'; % celda 1521
ex4omet = 'added_EX_4omet_e';
o2 = 'EX_o2_e';
glucose = 'EX_glc__D_e';

% condiciones iniciales: -100 glucosa y -1000 oxigeno
model_b = changeRxnBounds(model_b, glucose, -100, 'l');
model_b = changeRxnBounds(model_b, o2, -1000, 'l');

% ruta 01_01
model_01_01 = addReaction(model_b, 'added_3dhsk_34dhbz','3dhsk_c -> 34dhbz_c + h2o_c');
model_01_01 = addReaction(model_01_01, 'added_34dhbz_34dhbald','34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c');
model_01_01 = addFixedRxns(model_01_01, '1');

% ruta 07_01
model_07_01 = addReaction(model_b,'added_tyr__L_T4hcinnm','tyr__L_c -> T4hcinnm_c + nh4_c');
model_07_01 = addReaction(model_07_01,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c');
%sacc_model_07_01 = addReaction(sacc_model_07_01,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_m + o2_c -> 34dhcinm_c + fad_m + h2o_c + h_c');
model_07_01 = addReaction(model_07_01,'added_aux_fadh2','fadh2_m <=> fadh2_c');
model_07_01 = addReaction(model_07_01,'added_aux_fad','fad_m <=> fad_c');
model_07_01 = addReaction(model_07_01,'added_34dhcinm_caffcoa','34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c');
model_07_01 = addReaction(model_07_01,'added_caffcoa_34dhbald','caffcoa_c + h2o_c -> 34dhbald_c + accoa_c');
model_07_01 = addFixedRxns(model_07_01,'1');

% ruta 02_01
model_02_01 = addReaction(model_b,'added_4hbz_34dhbz','4hbz_c + nadph_c + o2_c + h_c -> 34dhbz_c + nadp_c + h2o_c');
model_02_01 = addReaction(model_02_01,'added_34dhbz_34dhbald','34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c');
model_02_01 = addFixedRxns(model_02_01,'1');

model_test = model_01_01;

%model_test = changeRxnBounds(model_test,'added_EX_4omet_e',0,'l');

% Maxima tasa de crecimiento
growthRate = optimizeCbModel(model_test, 'max');
growthRateValue = growthRate.f;
biomassMinValue = 0;

% Maxima tasa de producccion de 4omet
model_test = changeObjective(model_test, ex4omet);
max4omet = optimizeCbModel(model_test, 'max');
max4ometValue = max4omet.f;

% Constraints de Wild-Type y Mutant-Type
constrWT = struct('rxnList', {{biomass}}, 'rxnValues', growthRateValue, 'rxnBoundType','b');
constrMT = struct('rxnList', {{biomass, ex4omet}},'rxnValues', [biomassMinValue, max4ometValue], 'rxnBoundType', 'bb');

% FVA
[minFluxesW, maxFluxesW, minFluxesM, maxFluxesM, ~, ~] = FVAOptForce(model_test, constrWT, constrMT);

% Constraint de optimizacion
constrOpt = struct('rxnList', {{glucose, o2, biomass, ex4omet}}, 'values', [-100, -1000, biomassMinValue, max4ometValue]);

exportSetToGAMS(model_test.rxns, 'GAMS/Reactions.txt');

exportInputsMustToGAMS(model_test, minFluxesW, maxFluxesW, constrOpt, 'GAMS/MustToGAMS');

% Excluir los resultados de las reacciones de primer orden y tambien las reacciones de intercambio
constrOpt = struct('rxnList', {{glucose, o2, biomass, ex4omet}}, 'values', [-100, -1000, biomassMinValue, max4ometValue]);
exchangeRxns = model_test.rxns(cellfun(@isempty, strfind(model_test.rxns, 'EX_')) == 0);
excludedRxns = unique([mustUSet; mustLSet; exchangeRxns]);

exportInputsMustOrder2ToGAMS(model_test, minFluxesW, maxFluxesW, constrOpt, excludedRxns,inputFolder='GAMS/MustOrder2ToGAMS');

% OptForce
targetRxn = ex4omet;
biomassRxn = biomass;
k = 1;
nSets = 1;
constrOpt = struct('rxnList', {{glucose, o2, biomass}}, 'values', [-100, -1000, biomassMinValue]);

%exportInputsOptForceToGAMS(model_test, targetRxn);