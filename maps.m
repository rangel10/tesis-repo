% Visualization script for S. cerevisiae

% solver gurobi
changeCobraSolver('glpk','all');

% modelo base
model_b = readCbModel('iMM904.mat');

% condiciones iniciales: -100 glucosa y -1000 oxigeno
model_b = changeRxnBounds(model_b, 'EX_glc__D_e',-100,'l');
model_b = changeRxnBounds(model_b,'EX_o2_e',-1000,'l');

% ruta 01_01
model_01_01 = addReaction(model_b,'added_3dhsk_34dhbz','3dhsk_c -> 34dhbz_c + h2o_c');
model_01_01 = addReaction(model_01_01,'added_34dhbz_34dhbald','34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c');
model_01_01 = addFixedRxns(model_01_01,'1');

% ruta 07_01
model_07_01 = addReaction(model_b,'added_tyr__L_T4hcinnm','tyr__L_c -> T4hcinnm_c + nh4_c');
model_07_01 = addReaction(model_07_01,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c');
%sacc_model_07_01 = addReaction(sacc_model_07_01,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_m + o2_c -> 34dhcinm_c + fad_m + h2o_c + h_c');
model_07_01 = addReaction(model_07_01,'added_aux_fadh2','fadh2_m <=> fadh2_c');
model_07_01 = addReaction(model_07_01,'added_aux_fad','fad_m <=> fad_c');
model_07_01 = addReaction(model_07_01,'added_34dhcinm_caffcoa','34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c');
model_07_01 = addReaction(model_07_01,'added_caffcoa_34dhbald','caffcoa_c + h2o_c -> 34dhbald_c + accoa_c');
model_07_01 = addFixedRxns(model_07_01,'1');

% ruta nativa
model_nat = addReaction(model_b, 'added_phe__L_cinnm', 'phe__L_c -> cinnm_c + nh4_c');
model_nat = addReaction(model_nat, 'added_cinnm_T4hcinnm', 'cinnm_c + nadph_c + o2_c -> T4hcinnm_c + nadp_c + h2o_c');
model_nat = addReaction(model_nat,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c');
model_nat = addReaction(model_nat,'added_aux_fadh2','fadh2_m <=> fadh2_c');
model_nat = addReaction(model_nat,'added_aux_fad','fad_m <=> fad_c');
model_nat = addReaction(model_nat,'added_34dhcinm_caffcoa','34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c');
model_nat = addReaction(model_nat,'added_caffcoa_34dhbald','caffcoa_c + h2o_c -> 34dhbald_c + accoa_c');
model_nat = addFixedRxns(model_nat, '1');


model_test = model_01_01;
fba = optimizeCbModel(model_test,'max');
fluxes = fba.x;

outmodel = writeCbModel(model_test, 'sbml','sacc_model_01.xml');
% writeCbModel(model_nat, 'sbml','sacc_model_nat.xml');
% writeCbModel(model_01_01, 'sbml','sacc_model_01.xml');
% writeCbModel(model_07_01, 'sbml','sacc_model_07.xml');
%[Involved_mets, Dead_ends] = draw_by_rxn(model_test, model_test.rxns, 'true', 'struc', {''}, {''}, fluxes);

