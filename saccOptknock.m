% Optknock para mejores rutas de Saccharomyces cerevisiae 4OMET
% para rutas 01_01, 07_01 y 02_01

% solver gurobi
changeCobraSolver('gurobi','all');

% modelo base
model_b = readCbModel('iMM904.mat');
biomass = 'BIOMASS_SC5_notrace'; % celda 1521
ex4omet = 'added_EX_4omet_e';

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

% ruta 02_01
model_02_01 = addReaction(model_b,'added_4hbz_34dhbz','4hbz_c + nadph_c + o2_c + h_c -> 34dhbz_c + nadp_c + h2o_c');
model_02_01 = addReaction(model_02_01,'added_34dhbz_34dhbald','34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c');
model_02_01 = addFixedRxns(model_02_01,'1');

% ruta nativa
model_nat = addReaction(model_b, 'added_phe__L_cinnm', 'phe__L_c -> cinnm_c + nh4_c');
model_nat = addReaction(model_nat, 'added_cinnm_T4hcinnm', 'cinnm_c + nadph_c + o2_c -> T4hcinnm_c + nadp_c + h2o_c');
model_nat = addReaction(model_nat,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c');
model_nat = addReaction(model_nat,'added_aux_fadh2','fadh2_m <=> fadh2_c');
model_nat = addReaction(model_nat,'added_aux_fad','fad_m <=> fad_c');
model_nat = addReaction(model_nat,'added_34dhcinm_caffcoa','34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c');
model_nat = addReaction(model_nat,'added_caffcoa_34dhbald','caffcoa_c + h2o_c -> 34dhbald_c + accoa_c');
model_nat = addFixedRxns(model_nat, '1');


%model_01_01 = changeRxnBounds(model_01_01,'added_EX_4omet_e',0,'l');


% parametros
threshold = 25;
numDel = 1;
percent = 0.01;
minObj = 25;

model_test = model_nat;
fba = optimizeCbModel(model_test,'max');
fluxb = fba.f;
%rxns = model_test.rxns;
options = struct('targetRxn',ex4omet,'numDel',numDel);
constrOpt = struct('rxnList', {{biomass, ex4omet}},'values', [fluxb*percent, minObj], 'sense', ['G', 'G']);
exchangeRxns = model_test.rxns(cellfun(@isempty, strfind(model_test.rxns, 'EX_')) == 0);
rxns = setdiff(model_test.rxns, exchangeRxns);

% abrir archivo de resultados
fid = fopen('optknock results/result_nat_1D_1P_25TH_25MO.txt','w');

% Optknock
fprintf(fid,'\n\n**********************Resultados nat: %i deletions, %g biomass, %i runs, %g min objective********************\n\n',numDel, percent, threshold, minObj);
previousResult = cell(threshold,1);
contprev = 1;
for i=1:threshold
%     if isempty(previousResult{1})
%         result = OptKnock(model_test,rxns,options,constrOpt,previousResult,true);
%     else
%         result = OptKnock(model_test,rxns,options,constrOpt,previousResult,true);
%     end
    result = OptKnock(model_test,rxns,options,constrOpt,previousResult,false);
    solset = result.rxnList;
    if ~isempty(solset)
        fprintf(fid,'\n---------------------Resultado %i------------------------\n',i);
        [type, maxGrowth, maxProd, minProd] = analyzeOptKnock(model_test, result.rxnList, ex4omet);
        fprintf(fid,'Rxns: ');
        fprintf(fid,'%s ',result.rxnList{:});
        fprintf(fid,'\nObj: %f',result.obj);
        fprintf(fid,'\nBiomass: %f',result.fluxes(1521));
        fprintf(fid,'\nMax prod: %f',maxProd);
        fprintf(fid,'\nMin prod: %f',minProd);
        fprintf(fid,'\nMax growth: %f',maxGrowth);
        fprintf(fid,'\nType: %s',type);
        previousResult{contprev} = solset;
        contprev = contprev + 1;
    else 
        break;
    end
    
end

%singleProductionEnvelope(model_test,result.rxnList,'added_EX_4omet_e',biomass,showPlot=true);

% cerrar archivo de resultados
fprintf(fid,'\n');
fclose(fid);
