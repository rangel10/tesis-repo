% Saccharomyces cerevisiae
changeCobraSolver('glpk','all');
% Leer modelo
sacc_model = readCbModel('iMM904.mat');
ecoli_model1 = readCbModel('iECW_1372.mat');
ecoli_model2 = readCbModel('iWFL_1372.mat');

% exportar xls de modelo base
%outmodel = writeCbModel(sacc_model, 'xls','sacc_model.xls');

% condiciones iniciales: -100 glucosa y -1000 oxigeno
sacc_model_b = changeRxnBounds(sacc_model, 'EX_glc__D_e',-100,'l');
sacc_model_b = changeRxnBounds(sacc_model_b,'EX_o2_e',-1000,'l');

% Exportar xls de modelo con condiciones iniciales
% outmodel = writeCbModel(sacc_model_b, 'xls','sacc_model_a.xls');
% outmodel = writeCbModel(sacc_model_b, 'sbml','sacc_model_a.xml');
% outmodel_ecoli1 = writeCbModel(ecoli_model1, 'xls', 'ecoli_model_iECW.xls');
% outmodel_ecoli2 = writeCbModel(ecoli_model2, 'xls', 'ecoli_model_iWFL.xls');

% Analisis modelo base con condiciones iniciales
FBAsolution_b = optimizeCbModel(sacc_model_b,'max');
F_b = FBAsolution_b.f;

% Analisis para ruta nativa
% Real. 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn -> phpyr -> cinnm -> 4cou -> 4hbald -> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c <=> pphn_c     // ->
% * h_c + pphn_c -> co2_c + h2o_c + phpyr_c
% * phpyr_c + glu__L_c <=> phe__L_c + akg_c 
% * phe__L_c -> cinnm_c + nh4_c     // No esta en modelo
% * cinnm_c + nadph_c + o2_c -> T4hcinnm_c + nadp_c + h2o_c     // No esta en modelo
% * T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c     // No esta en modelo
% * 34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c    // No esta en modelo (?)
% * caffcoa_c + h2o_c -> 34dhbald_c + accoa_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% Nativa
sacc_model_nat = addReaction(sacc_model_b, 'added_phe__L_cinnm', 'phe__L_c -> cinnm_c + nh4_c');
sacc_model_nat = addReaction(sacc_model_nat, 'added_cinnm_T4hcinnm', 'cinnm_c + nadph_c + o2_c -> T4hcinnm_c + nadp_c + h2o_c');
sacc_model_nat = addReaction(sacc_model_nat,'added_T4hcinnm_34dhcinm', 'T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c');
%sacc_model_nat = addReaction(sacc_model_nat,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_m + o2_c -> 34dhcinm_c + fad_m + h2o_c + h_c');

%sacc_model_nat = addReaction(sacc_model_nat,'added_T4hcinnm_34dhcinm','T4hcinnm_c + nadph_c + o2_c -> 34dhcinm_c + nadp_c + h2o_c');

% aux?
sacc_model_nat = addReaction(sacc_model_nat,'added_aux_fadh2', 'fadh2_m <=> fadh2_c');
sacc_model_nat = addReaction(sacc_model_nat,'added_aux_fad', 'fad_m <=> fad_c');

sacc_model_nat = addReaction(sacc_model_nat,'added_34dhcinm_caffcoa', '34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c');
sacc_model_nat = addReaction(sacc_model_nat,'added_caffcoa_34dhbald', 'caffcoa_c + h2o_c -> 34dhbald_c + accoa_c');

% finales
sacc_model_nat = addFixedRxns(sacc_model_nat, '1');

% FBA
FBAsolution_nat = optimizeCbModel(sacc_model_nat,'max');
F_nat = FBAsolution_nat.f;

% Nativa 2
sacc_model_nat2 = addReaction(sacc_model_b, 'added_Largn_phe__L', 'Largn_c + h_c -> co2_c + phe__L_c + h2o_c');
sacc_model_nat2 = addReaction(sacc_model_nat2, 'added_phe__L_cinnm', 'phe__L_c -> cinnm_c + nh4_c');
sacc_model_nat2 = addReaction(sacc_model_nat2, 'added_cinnm_T4hcinnm', 'cinnm_c + nadph_c + o2_c -> T4hcinnm_c + nadp_c + h2o_c');
sacc_model_nat2 = addReaction(sacc_model_nat2,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c');
%sacc_model_nat = addReaction(sacc_model_nat,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_m + o2_c -> 34dhcinm_c + fad_m + h2o_c + h_c');

%sacc_model_nat = addReaction(sacc_model_nat,'added_T4hcinnm_34dhcinm','T4hcinnm_c + nadph_c + o2_c -> 34dhcinm_c + nadp_c + h2o_c');

% aux?
sacc_model_nat2 = addReaction(sacc_model_nat2,'added_aux_fadh2','fadh2_m <=> fadh2_c');
sacc_model_nat2 = addReaction(sacc_model_nat2,'added_aux_fad','fad_m <=> fad_c');

sacc_model_nat2 = addReaction(sacc_model_nat2,'added_34dhcinm_caffcoa','34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c');
sacc_model_nat2 = addReaction(sacc_model_nat2,'added_caffcoa_34dhbald','caffcoa_c + h2o_c -> 34dhbald_c + accoa_c');

% finales
sacc_model_nat2 = addFixedRxns(sacc_model_nat2, '2');

% FBA
FBAsolution_nat2 = optimizeCbModel(sacc_model_nat2,'max');
F_nat2 = FBAsolution_nat2.f;

% Analisis para ruta 2.1/3.1 - 01_01

% 2.1) 2dda7p -> 3dhq <=> 3dhsk -> 34dhbz <=> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c -> 34dhbz_c + h2o_c     // No esta en modelo
% * 34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c     // No esta en modelo (?)

% Agregar o modificar reacciones faltantes

% 2.1
sacc_model_01_01 = addReaction(sacc_model_b,'added_3dhsk_34dhbz', '3dhsk_c -> 34dhbz_c + h2o_c');
sacc_model_01_01 = addReaction(sacc_model_01_01,'added_34dhbz_34dhbald', '34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c');

% 3.1 y finales 
sacc_model_01_01 = addFixedRxns(sacc_model_01_01,'1');

% FBA
FBAsolution_01_01 = optimizeCbModel(sacc_model_01_01,'max');
F_01_01 = FBAsolution_01_01.f;

% Analisis para ruta 2.1/3.2 - 01_02

% 2.1) 2dda7p -> 3dhq <=> 3dhsk -> 34dhbz <=> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c -> 34dhbz_c + h2o_c     // No esta en modelo
% * 34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c     // No esta en modelo (?)

% Agregar o modificar reacciones faltantes

% 2.1
sacc_model_01_02 = addReaction(sacc_model_b,'added_3dhsk_34dhbz','3dhsk_c -> 34dhbz_c + h2o_c');
sacc_model_01_02 = addReaction(sacc_model_01_02,'added_34dhbz_34dhbald','34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c');

% 3.2 y finales 
sacc_model_01_02 = addFixedRxns(sacc_model_01_02,'2');

% FBA
FBAsolution_01_02 = optimizeCbModel(sacc_model_01_02,'max');
F_01_02 = FBAsolution_01_02.f;

% Analisis para ruta 2.2/3.1 - 02_01

%  2.2) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor -> 4hbz -> 34dhbz <=> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c -> 4hbz_c + pyr_c
% * 4hbz_c + nadph_c + o2_c + h_c -> 34dhbz_c + nadp_c + h2o_c     // No esta en modelo
% * 34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% 2.2
sacc_model_02_01 = addReaction(sacc_model_b,'added_4hbz_34dhbz','4hbz_c + nadph_c + o2_c + h_c -> 34dhbz_c + nadp_c + h2o_c');
sacc_model_02_01 = addReaction(sacc_model_02_01,'added_34dhbz_34dhbald','34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c');

% 3.1 y finales
sacc_model_02_01 = addFixedRxns(sacc_model_02_01,'1');

% FBA
FBAsolution_02_01 = optimizeCbModel(sacc_model_02_01,'max');
F_02_01 = FBAsolution_02_01.f;

% Analisis para ruta 2.2/3.2 - 02_02

%  2.2) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor -> 4hbz -> 34dhbz <=> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c -> 4hbz_c + pyr_c
% * 4hbz_c + nadph_c + o2_c + h_c -> 34dhbz_c + nadp_c + h2o_c     // No esta en modelo
% * 34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% 2.2
sacc_model_02_02 = addReaction(sacc_model_b,'added_4hbz_34dhbz','4hbz_c + nadph_c + o2_c + h_c -> 34dhbz_c + nadp_c + h2o_c');
sacc_model_02_02 = addReaction(sacc_model_02_02,'added_34dhbz_34dhbald','34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c');

% 3.2 y finales
sacc_model_02_02 = addFixedRxns(sacc_model_02_02,'2');

% FBA
FBAsolution_02_02 = optimizeCbModel(sacc_model_02_02,'max');
F_02_02 = FBAsolution_02_02.f;

% Analisis para ruta 2.3/3.1 - 03_01

% 2.3) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor -> 4hbz <=> 4hbald -> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // sk5mp
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // sk5mp ->
% * 3psme_c -> chor_c + pi_c
% * chor_c -> 4hbz_c + pyr_c
% * 4hbz_c + atp_c + nadph_c + h_c <=> 4hbald_c + amp_c + nadp_c + ppi_c     // No esta en modelo (?)
% * 4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c     // No esta en modelo (?)

% Agregar o modificar reacciones faltantes

% 2.3
sacc_model_03_01 = addReaction(sacc_model_b,'added_4hbz_4hbald','4hbz_c + atp_c + nadph_c + h_c <=> 4hbald_c + amp_c + nadp_c + ppi_c');
sacc_model_03_01 = addReaction(sacc_model_03_01,'added_4hbald_34dhbald','4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c');

% 3.1 y finales
sacc_model_03_01 = addFixedRxns(sacc_model_03_01,'1');

% FBA
FBAsolution_03_01 = optimizeCbModel(sacc_model_03_01,'max');
F_03_01 = FBAsolution_03_01.f;

% Analisis para ruta 2.3/3.2 - 03_02

% 2.3) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor -> 4hbz <=> 4hbald -> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // sk5mp
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // sk5mp ->
% * 3psme_c -> chor_c + pi_c
% * chor_c -> 4hbz_c + pyr_c
% * 4hbz_c + atp_c + nadph_c + h_c <=> 4hbald_c + amp_c + nadp_c + ppi_c     // No esta en modelo (?)
% * 4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c     // No esta en modelo (?)

% Agregar o modificar reacciones faltantes

% 2.3
sacc_model_03_02 = addReaction(sacc_model_b,'added_4hbz_4hbald','4hbz_c + atp_c + nadph_c + h_c <=> 4hbald_c + amp_c + nadp_c + ppi_c');
sacc_model_03_02 = addReaction(sacc_model_03_02,'added_4hbald_34dhbald','4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c');

% 3.2 y finales
sacc_model_03_02 = addFixedRxns(sacc_model_03_02,'2');

% FBA
FBAsolution_03_02 = optimizeCbModel(sacc_model_03_02,'max');
F_03_02 = FBAsolution_03_02.f;

% Analisis para ruta 2.4/3.1 - 04_01

%  2.4) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn -> 34hpp <=> tyr__L -> 4cou -> 4hbald -> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c <=> pphn_c     // ->
% * nad_c + pphn_c -> 34hpp_c + co2_c + nadh_c || pphn_c + nadp_c -> 34hpp_c + co2_c + nadph_c
% * 34hpp_c + glu__L_c <=> akg_c + tyr__L_c || 34hpp_m + glu__L_m <=> akg_m + tyr__L_m || 34hpp_x + glu__L_x <=> akg_x + tyr__L_x     // ->
% *** 34hpp_c + h_c <=> 34hpp_m + h_m || 34hpp_c + h_c <=> 34hpp_x + h_x
% * tyr__L_c -> T4hcinnm_c + nh4_c     // No esta en modelo
% * T4hcinnm_c + h2o_c -> 4hbald_c + ac_c     // No esta en modelo
% * 4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% 2.4
sacc_model_04_01 = addReaction(sacc_model_b,'added_tyr__L_T4hcinnm','tyr__L_c -> T4hcinnm_c + nh4_c');
sacc_model_04_01 = addReaction(sacc_model_04_01,'added_T4hcinnm_4hbald','T4hcinnm_c + h2o_c -> 4hbald_c + ac_c');
sacc_model_04_01 = addReaction(sacc_model_04_01,'added_4hbald_34hbald','4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c');

% 3.1 y finales
sacc_model_04_01 = addFixedRxns(sacc_model_04_01,'1');

% FBA
FBAsolution_04_01 = optimizeCbModel(sacc_model_04_01,'max');
F_04_01 = FBAsolution_04_01.f;

% Analisis para ruta 2.4/3.2 - 04_02

%  2.4) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn -> 34hpp <=> tyr__L -> 4cou -> 4hbald -> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c <=> pphn_c     // ->
% * nad_c + pphn_c -> 34hpp_c + co2_c + nadh_c || pphn_c + nadp_c -> 34hpp_c + co2_c + nadph_c
% * 34hpp_c + glu__L_c <=> akg_c + tyr__L_c || 34hpp_m + glu__L_m <=> akg_m + tyr__L_m || 34hpp_x + glu__L_x <=> akg_x + tyr__L_x     // ->
% *** 34hpp_c + h_c <=> 34hpp_m + h_m || 34hpp_c + h_c <=> 34hpp_x + h_x
% * tyr__L_c -> T4hcinnm_c + nh4_c     // No esta en modelo
% * T4hcinnm_c + h2o_c -> 4hbald_c + ac_c     // No esta en modelo
% * 4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% 2.4
sacc_model_04_02 = addReaction(sacc_model_b,'added_tyr__L_T4hcinnm','tyr__L_c -> T4hcinnm_c + nh4_c');
sacc_model_04_02 = addReaction(sacc_model_04_02,'added_T4hcinnm_4hbald','T4hcinnm_c + h2o_c -> 4hbald_c + ac_c');
sacc_model_04_02 = addReaction(sacc_model_04_02,'added_4hbald_34hbald','4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c');

% 3.2 y finales
sacc_model_04_02 = addFixedRxns(sacc_model_04_02,'2');

% FBA
FBAsolution_04_02 = optimizeCbModel(sacc_model_04_02,'max');
F_04_02 = FBAsolution_04_02.f;

% Analisis para ruta 2.5/3.1 - 05_01

%  2.5) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn <=> Largn -> tyr__L -> 4cou -> 4hbald -> 34dhbald 
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c <=> pphn_c     // ->
% * pphn_c + glu__L_c <=> Largn_c + akg_c || pphn_c + asp__L_c <=> Largn_c + oaa_c     // No esta en modelo
% * Largn_c + nad_c -> tyr__L_c + co2_c + nadh_c || Largn_c + nadp_c -> tyr__L_c + co2_c + nadph_c     // No esta en modelo
% * tyr__L_c -> T4hcinnm_c + nh4_c     // No esta en modelo
% * T4hcinnm_c + h2o_c -> 4hbald_c + ac_c     // No esta en modelo
% * 4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% 2.5
sacc_model_05_01 = addReaction(sacc_model_b,'added_pphn_Largn', 'pphn_c + glu__L_c <=> Largn_c + akg_c');
sacc_model_05_01 = addReaction(sacc_model_05_01,'added_Largn_tyr__L', 'Largn_c + nadp_c -> tyr__L_c + co2_c + nadph_c');
sacc_model_05_01 = addReaction(sacc_model_05_01,'added_tyr__L_T4hcinnm','tyr__L_c -> T4hcinnm_c + nh4_c');
sacc_model_05_01 = addReaction(sacc_model_05_01,'added_T4hcinnm_4hbald','T4hcinnm_c + h2o_c -> 4hbald_c + ac_c');
sacc_model_05_01 = addReaction(sacc_model_05_01,'added_4hbald_34dhbald','4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c');

% 3.1 y finales
sacc_model_05_01 = addFixedRxns(sacc_model_05_01,'1');

% FBA
FBAsolution_05_01 = optimizeCbModel(sacc_model_05_01,'max');
F_05_01 = FBAsolution_05_01.f;

% Analisis para ruta 2.5/3.2 - 05_02

%  2.5) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn <=> Largn -> tyr__L -> 4cou -> 4hbald -> 34dhbald 
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c <=> pphn_c     // ->
% * pphn_c + glu__L_c <=> Largn_c + akg_c || pphn_c + asp__L_c <=> Largn_c + oaa_c     // No esta en modelo
% * Largn_c + nad_c -> tyr__L_c + co2_c + nadh_c || Largn_c + nadp_c -> tyr__L_c + co2_c + nadph_c     // No esta en modelo
% * tyr__L_c -> T4hcinnm_c + nh4_c     // No esta en modelo
% * T4hcinnm_c + h2o_c -> 4hbald_c + ac_c     // No esta en modelo
% * 4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% 2.5
sacc_model_05_02 = addReaction(sacc_model_b,'added_tyr__L_T4hcinnm','tyr__L_c -> T4hcinnm_c + nh4_c');
sacc_model_05_02 = addReaction(sacc_model_05_02,'added_T4hcinnm_4hbald','T4hcinnm_c + h2o_c -> 4hbald_c + ac_c');
sacc_model_05_02 = addReaction(sacc_model_05_02,'added_4hbald_34dhbald','4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c');

% 3.2 y finales
sacc_model_05_02 = addFixedRxns(sacc_model_05_02,'2');

% FBA
FBAsolution_05_02 = optimizeCbModel(sacc_model_05_02,'max');
F_05_02 = FBAsolution_05_02.f;

% Analisis para ruta 2.7/3.1 - 07_01

%  2.7) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn -> 34hpp <=> tyr__L -> 4cou -> caff <=> caffcoa -> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c <=> pphn_c     // ->
% * nad_c + pphn_c -> 34hpp_c + co2_c + nadh_c || pphn_c + nadp_c -> 34hpp_c + co2_c + nadph_c
% * 34hpp_c + glu__L_c <=> akg_c + tyr__L_c || 34hpp_m + glu__L_m <=> akg_m + tyr__L_m || 34hpp_x + glu__L_x <=> akg_x + tyr__L_x     // ->
% *** 34hpp_c + h_c <=> 34hpp_m + h_m || 34hpp_c + h_c <=> 34hpp_x + h_x
% * tyr__L_c -> T4hcinnm_c + nh4_c     // No esta en modelo
% * T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c     // No esta en modelo
% * 34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c    // No esta en modelo (?)
% * caffcoa_c + h2o_c -> 34dhbald_c + accoa_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% 2.7
sacc_model_07_01 = addReaction(sacc_model_b,'added_tyr__L_T4hcinnm', 'tyr__L_c -> T4hcinnm_c + nh4_c');
sacc_model_07_01 = addReaction(sacc_model_07_01,'added_T4hcinnm_34dhcinm', 'T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c');
%sacc_model_07_01 = addReaction(sacc_model_07_01,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_m + o2_c -> 34dhcinm_c + fad_m + h2o_c + h_c');

%sacc_model_07_01 = addReaction(sacc_model_07_01,'added_T4hcinnm_34dhcinm','T4hcinnm_c + nadph_c + o2_c -> 34dhcinm_c + nadp_c + h2o_c');

% aux?
sacc_model_07_01 = addReaction(sacc_model_07_01,'added_aux_fadh2', 'fadh2_m <=> fadh2_c');
sacc_model_07_01 = addReaction(sacc_model_07_01,'added_aux_fad', 'fad_m <=> fad_c');

sacc_model_07_01 = addReaction(sacc_model_07_01,'added_34dhcinm_caffcoa', '34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c');
sacc_model_07_01 = addReaction(sacc_model_07_01,'added_caffcoa_34dhbald', 'caffcoa_c + h2o_c -> 34dhbald_c + accoa_c');

% 3.1 y finales
sacc_model_07_01 = addFixedRxns(sacc_model_07_01,'1');

% FBA
FBAsolution_07_01 = optimizeCbModel(sacc_model_07_01,'max');
F_07_01 = FBAsolution_07_01.f;

% Analisis para ruta 2.7/3.2 - 07_02

%  2.7) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn -> 34hpp <=> tyr__L -> 4cou -> caff <=> caffcoa -> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c <=> pphn_c     // ->
% * nad_c + pphn_c -> 34hpp_c + co2_c + nadh_c || pphn_c + nadp_c -> 34hpp_c + co2_c + nadph_c
% * 34hpp_c + glu__L_c <=> akg_c + tyr__L_c || 34hpp_m + glu__L_m <=> akg_m + tyr__L_m || 34hpp_x + glu__L_x <=> akg_x + tyr__L_x     // ->
% *** 34hpp_c + h_c <=> 34hpp_m + h_m || 34hpp_c + h_c <=> 34hpp_x + h_x
% * tyr__L_c -> T4hcinnm_c + nh4_c     // No esta en modelo
% * T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c     // No esta en modelo
% * 34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c    // No esta en modelo (?)
% * caffcoa_c + h2o_c -> 34dhbald_c + accoa_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% 2.7
sacc_model_07_02 = addReaction(sacc_model_b,'added_tyr__L_T4hcinnm','tyr__L_c -> T4hcinnm_c + nh4_c');
sacc_model_07_02 = addReaction(sacc_model_07_02,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c');
%sacc_model_07_02 = addReaction(sacc_model_07_02,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_m + o2_c -> 34dhcinm_c + fad_m + h2o_c + h_c');

% aux?
sacc_model_07_02 = addReaction(sacc_model_07_02,'added_aux_fadh2','fadh2_m <=> fadh2_c');
sacc_model_07_02 = addReaction(sacc_model_07_02,'added_aux_fad','fad_m <=> fad_c');

sacc_model_07_02 = addReaction(sacc_model_07_02,'added_34dhcinm_caffcoa','34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c');
sacc_model_07_02 = addReaction(sacc_model_07_02,'added_caffcoa_34dhbald','caffcoa_c + h2o_c -> 34dhbald_c + accoa_c');

% 3.2 y finales
sacc_model_07_02 = addFixedRxns(sacc_model_07_02,'2');

% FBA
FBAsolution_07_02 = optimizeCbModel(sacc_model_07_02,'max');
F_07_02 = FBAsolution_07_02.f;

% Analisis para ruta 2.9/3.1 - 09_01

%  2.9) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn -> 34hpp <=> tyr__L -> 4cou <=> coucoa -> 4hbald -> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c <=> pphn_c     // ->
% * nad_c + pphn_c -> 34hpp_c + co2_c + nadh_c || pphn_c + nadp_c -> 34hpp_c + co2_c + nadph_c
% * 34hpp_c + glu__L_c <=> akg_c + tyr__L_c || 34hpp_m + glu__L_m <=> akg_m + tyr__L_m || 34hpp_x + glu__L_x <=> akg_x + tyr__L_x     // ->
% *** 34hpp_c + h_c <=> 34hpp_m + h_m || 34hpp_c + h_c <=> 34hpp_x + h_x
% * tyr__L_c -> T4hcinnm_c + nh4_c     // No esta en modelo
% * T4hcinnm_c + atp_c + coa_c -> coucoa_c + amp_c + ppi_c     // No esta en modelo
% * coucoa_c + h2o_c → 4hbald_c + accoa_c     // No esta en modelo
% * 4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% 2.9
sacc_model_09_01 = addReaction(sacc_model_b,'added_tyr__L_T4hcinnm','tyr__L_c -> T4hcinnm_c + nh4_c');
%sacc_model_09_01 = addReaction(sacc_model_09_01,'added_T4hcinnm_coucoa','T4hcinnm_c + atp_c + coa_c -> coucoa_c + amp_c + ppi_c');
sacc_model_09_01 = addReaction(sacc_model_09_01,'added_T4hcinnm_coucoa','T4hcinnm_c + atp_c + coa_c -> coucoa_c + amp_c + ppi_c');
sacc_model_09_01 = addReaction(sacc_model_09_01,'added_coucoa_4hbald','coucoa_c + h2o_c -> 4hbald_c + accoa_c');
%sacc_model_09_01 = addReaction(sacc_model_09_01,'added_4hbald_34dhbald','4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c');
sacc_model_09_01 = addReaction(sacc_model_09_01,'added_4hbald_34dhbald','4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c');

% 3.1 y finales
sacc_model_09_01 = addFixedRxns(sacc_model_09_01,'1');

% FBA
FBAsolution_09_01 = optimizeCbModel(sacc_model_09_01,'max');
F_09_01 = FBAsolution_09_01.f;

% Analisis para ruta 2.9/3.2 - 09_02

%  2.9) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn -> 34hpp <=> tyr__L -> 4cou <=> coucoa -> 4hbald -> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c <=> pphn_c     // ->
% * nad_c + pphn_c -> 34hpp_c + co2_c + nadh_c || pphn_c + nadp_c -> 34hpp_c + co2_c + nadph_c
% * 34hpp_c + glu__L_c <=> akg_c + tyr__L_c || 34hpp_m + glu__L_m <=> akg_m + tyr__L_m || 34hpp_x + glu__L_x <=> akg_x + tyr__L_x     // ->
% *** 34hpp_c + h_c <=> 34hpp_m + h_m || 34hpp_c + h_c <=> 34hpp_x + h_x
% * tyr__L_c -> T4hcinnm_c + nh4_c     // No esta en modelo
% * T4hcinnm_c + atp_c + coa_c -> coucoa_c + amp_c + ppi_c     // No esta en modelo
% * coucoa_c + h2o_c → 4hbald_c + accoa_c     // No esta en modelo
% * 4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% 2.9
sacc_model_09_02 = addReaction(sacc_model_b,'added_tyr__L_T4hcinnm','tyr__L_c -> T4hcinnm_c + nh4_c');
sacc_model_09_02 = addReaction(sacc_model_09_02,'added_T4hcinnm_coucoa','T4hcinnm_c + atp_c + coa_c -> coucoa_c + amp_c + ppi_c');
sacc_model_09_02 = addReaction(sacc_model_09_02,'added_coucoa_4hbald','coucoa_c + h2o_c -> 4hbald_c + accoa_c');
sacc_model_09_02 = addReaction(sacc_model_09_02,'added_4hbald_34dhbald','4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c');

% 3.2 y finales
sacc_model_09_02 = addFixedRxns(sacc_model_09_02,'2');

% FBA
FBAsolution_09_02 = optimizeCbModel(sacc_model_09_02,'max');
F_09_02 = FBAsolution_09_02.f;

% Analisis para ruta 2.10/3.1 - 10_01

% 2.10) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn <=> Largn -> tyr__L -> 4cou -> caff <=> caffcoa -> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c <=> pphn_c     // ->
% * pphn_c + glu__L_c <=> Largn_c + akg_c || pphn_c + asp__L_c <=> Largn_c + oaa_c     // No esta en modelo
% * Largn_c + nad_c -> tyr__L_c + co2_c + nadh_c || Largn_c + nadp_c -> tyr__L_c + co2_c + nadph_c     // No esta en modelo
% * tyr__L_c -> T4hcinnm_c + nh4_c     // No esta en modelo
% * T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c     // No esta en modelo
% * 34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c     // No esta en modelo
% * caffcoa_c + h2o_c -> 34dhbald_c + accoa_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% 2.10
sacc_model_10_01 = addReaction(sacc_model_b,'added_pphn_Largn', 'pphn_c + glu__L_c <=> Largn_c + akg_c');
sacc_model_10_01 = addReaction(sacc_model_10_01,'added_Largn_tyr__L', 'Largn_c + nadp_c -> tyr__L_c + co2_c + nadph_c');
sacc_model_10_01 = addReaction(sacc_model_10_01,'added_tyr__L_T4hcinnm','tyr__L_c -> T4hcinnm_c + nh4_c');
sacc_model_10_01 = addReaction(sacc_model_10_01,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c');
%sacc_model_10_01 = addReaction(sacc_model_10_01,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_m + o2_c -> 34dhcinm_c + fad_m + h2o_c + h_c');

% aux?
sacc_model_10_01 = addReaction(sacc_model_10_01,'added_aux_fadh2','fadh2_m <=> fadh2_c');
sacc_model_10_01 = addReaction(sacc_model_10_01,'added_aux_fad','fad_m <=> fad_c');

sacc_model_10_01 = addReaction(sacc_model_10_01,'added_34dhcinm_caffcoa','34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c');
sacc_model_10_01 = addReaction(sacc_model_10_01,'added_caffcoa_34dhbald','caffcoa_c + h2o_c -> 34dhbald_c + accoa_c');

% 3.1 y finales
sacc_model_10_01 = addFixedRxns(sacc_model_10_01,'1');

% FBA
FBAsolution_10_01 = optimizeCbModel(sacc_model_10_01,'max');
F_10_01 = FBAsolution_10_01.f;

% Analisis para ruta 2.10/3.2 - 10_02

% 2.10) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn <=> Largn -> tyr__L -> 4cou -> caff <=> caffcoa -> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c <=> pphn_c     // ->
% * pphn_c + glu__L_c <=> Largn_c + akg_c || pphn_c + asp__L_c <=> Largn_c + oaa_c     // No esta en modelo
% * Largn_c + nad_c -> tyr__L_c + co2_c + nadh_c || Largn_c + nadp_c -> tyr__L_c + co2_c + nadph_c     // No esta en modelo
% * tyr__L_c -> T4hcinnm_c + nh4_c     // No esta en modelo
% * T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c     // No esta en modelo
% * 34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c     // No esta en modelo
% * caffcoa_c + h2o_c -> 34dhbald_c + accoa_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% 2.10
sacc_model_10_02 = addReaction(sacc_model_b,'added_tyr__L_T4hcinnm','tyr__L_c -> T4hcinnm_c + nh4_c');
sacc_model_10_02 = addReaction(sacc_model_10_02,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_c + o2_c -> 34dhcinm_c + fad_c + h2o_c + h_c');
%sacc_model_10_02 = addReaction(sacc_model_10_02,'added_T4hcinnm_34dhcinm','T4hcinnm_c + fadh2_m + o2_c -> 34dhcinm_c + fad_m + h2o_c + h_c');

% aux?
sacc_model_10_02 = addReaction(sacc_model_10_02,'added_aux_fadh2','fadh2_m <=> fadh2_c');
sacc_model_10_02 = addReaction(sacc_model_10_02,'added_aux_fad','fad_m <=> fad_c');

sacc_model_10_02 = addReaction(sacc_model_10_02,'added_34dhcinm_caffcoa','34dhcinm_c + atp_c + coa_c -> caffcoa_c + amp_c + ppi_c');
sacc_model_10_02 = addReaction(sacc_model_10_02,'added_caffcoa_34dhbald','caffcoa_c + h2o_c -> 34dhbald_c + accoa_c');

% 3.2 y finales
sacc_model_10_02 = addFixedRxns(sacc_model_10_02,'2');

% FBA
FBAsolution_10_02 = optimizeCbModel(sacc_model_10_02,'max');
F_10_02 = FBAsolution_10_02.f;

% Analisis para ruta 2.12/3.1 - 12_01

%  2.12) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn <=> Largn -> tyr__L -> 4cou <=> coucoa -> 4hbald -> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c <=> pphn_c     // ->
% * pphn_c + glu__L_c <=> Largn_c + akg_c || pphn_c + asp__L_c <=> Largn_c + oaa_c     // No esta en modelo
% * Largn_c + nad_c -> tyr__L_c + co2_c + nadh_c || Largn_c + nadp_c -> tyr__L_c + co2_c + nadph_c     // No esta en modelo
% * tyr__L_c -> T4hcinnm_c + nh4_c     // No esta en modelo
% * T4hcinnm_c + atp_c + coa_c -> coucoa_c + amp_c + ppi_c     // No esta en modelo
% * coucoa_c + h2o_c → 4hbald_c + accoa_c     // No esta en modelo
% * 4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% 2.12
sacc_model_12_01 = addReaction(sacc_model_b,'added_pphn_Largn', 'pphn_c + glu__L_c <=> Largn_c + akg_c');
sacc_model_12_01 = addReaction(sacc_model_12_01,'added_Largn_tyr__L', 'Largn_c + nadp_c -> tyr__L_c + co2_c + nadph_c');
sacc_model_12_01 = addReaction(sacc_model_12_01,'added_tyr__L_T4hcinnm','tyr__L_c -> T4hcinnm_c + nh4_c');
sacc_model_12_01 = addReaction(sacc_model_12_01,'added_T4hcinnm_coucoa','T4hcinnm_c + atp_c + coa_c -> coucoa_c + amp_c + ppi_c');
sacc_model_12_01 = addReaction(sacc_model_12_01,'added_coucoa_4hbald','coucoa_c + h2o_c -> 4hbald_c + accoa_c');
sacc_model_12_01 = addReaction(sacc_model_12_01,'added_4hbald_34dhbald','4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c');

% 3.1 y finales
sacc_model_12_01 = addFixedRxns(sacc_model_12_01,'1');

% FBA
FBAsolution_12_01 = optimizeCbModel(sacc_model_12_01,'max');
F_12_01 = FBAsolution_12_01.f;

% Analisis para ruta 2.12/3.2 - 12_02

%  2.12) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn <=> Largn -> tyr__L -> 4cou <=> coucoa -> 4hbald -> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c + h_c + nadph_c -> nadp_c + skm_c
% * atp_c + skm_c -> adp_c + h_c + skm3p_c     // skm5p=skm3p 
% * pep_c + skm3p_c <=> 3psme_c + pi_c     // ->
% * 3psme_c -> chor_c + pi_c
% * chor_c <=> pphn_c     // ->
% * pphn_c + glu__L_c <=> Largn_c + akg_c || pphn_c + asp__L_c <=> Largn_c + oaa_c     // No esta en modelo
% * Largn_c + nad_c -> tyr__L_c + co2_c + nadh_c || Largn_c + nadp_c -> tyr__L_c + co2_c + nadph_c     // No esta en modelo
% * tyr__L_c -> T4hcinnm_c + nh4_c     // No esta en modelo
% * T4hcinnm_c + atp_c + coa_c -> coucoa_c + amp_c + ppi_c     // No esta en modelo
% * coucoa_c + h2o_c → 4hbald_c + accoa_c     // No esta en modelo
% * 4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c     // No esta en modelo

% Agregar o modificar reacciones faltantes

% 2.12
sacc_model_12_02 = addReaction(sacc_model_b,'added_tyr__L_T4hcinnm','tyr__L_c -> T4hcinnm_c + nh4_c');
sacc_model_12_02 = addReaction(sacc_model_12_02,'added_T4hcinnm_coucoa','T4hcinnm_c + atp_c + coa_c -> coucoa_c + amp_c + ppi_c');
sacc_model_12_02 = addReaction(sacc_model_12_02,'added_coucoa_4hbald','coucoa_c + h2o_c -> 4hbald_c + accoa_c');
sacc_model_12_02 = addReaction(sacc_model_12_02,'added_4hbald_34dhbald','4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c');

% 3.2 y finales
sacc_model_12_02 = addFixedRxns(sacc_model_12_02,'2');

% FBA
FBAsolution_12_02 = optimizeCbModel(sacc_model_12_02,'max');
F_12_02 = FBAsolution_12_02.f;


% Best Models
% writeCbModel(sacc_model_01_01, 'xls','sacc_model_a_1.xls');
% writeCbModel(sacc_model_07_01, 'xls','sacc_model_a_7.xls');
% writeCbModel(sacc_model_nat, 'xls','sacc_model_a_n.xls');

% model 01_01
for i=1578:1585
    sacc_model_01_01.subSystems{i} = 'added';
end

% model 07_01
for i=1578:1589
    sacc_model_07_01.subSystems{i} = 'added';
end

% model nat
for i=1578:1590
    sacc_model_nat.subSystems{i} = 'added';
end
 
% writeCbModel(sacc_model_01_01, 'sbml','sacc_model_a_1.xml');
% writeCbModel(sacc_model_07_01, 'sbml','sacc_model_a_7.xml');
% writeCbModel(sacc_model_nat, 'sbml','sacc_model_a_n.xml');