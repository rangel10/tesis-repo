% Saccharomyces cerevisiae

% Leer modelo
sacc_model = readCbModel('iMM904.mat');

% exportar xls de modelo base
% outmodel = writeCbModel(sacc_model, 'xls','sacc_model.xls');

% condiciones iniciales: -100 glucosa y -1000 oxigeno
sacc_model_b = changeRxnBounds(sacc_model, 'EX_glc__D_e',-100,'l');
sacc_model_b = changeRxnBounds(sacc_model_b,'EX_o2_e',-1000,'l');

% Exportar xls de modelo con condiciones iniciales
% outmodel = writeCbModel(sacc_model_a, 'xls','sacc_model_a.xls');


% Analisis modelo base con condiciones iniciales

FBAsolution_b = optimizeCbModel(sacc_model_b,'max');
F_b = FBAsolution_b.f;

% Analisis para ruta 2.1/3.1 - 01_01

% 2.1) 2dda7p -> 3dhq <=> 3dhsk -> 34dhbz <=> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c -> 34dhbz_c + h2o_c     // No esta en modelo
% * 34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c     // No esta en modelo (?)
% 
% 3.1) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn -> 34hpp <=> tyr__L -> tym
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
% * tyr__L_c + h_c -> tym_c + co2_c     // No esta en modelo
%
% Reacciones finales
% 
% added_tym_34dhbald_norcrg
% * 34dhbald_c + tym_c -> norcrg_c + h2o_c + h_c
%
% added_norcrg_norbell
% * norcrg_c + nadph_c + h_c -> norbell_c + nadp_c
% 
% added_norbell_4omet
% * amet_c + norbell_c -> 4omet_c + ahcys_c + h_c
% 
% added_aux_4omet
%  * 4omet_c <=> 4omet_e
%
% EX_4omet_e
% * 4omet_e ->

% Agregar o modificar reacciones faltantes

% 2.1
sacc_model_01_01 = addReaction(sacc_model_b,'added_3dhsk_34dhbz','3dhsk_c -> 34dhbz_c + h2o_c');
sacc_model_01_01 = addReaction(sacc_model_01_01,'added_34dhbz_34dhbald','34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c');

% 3.1
sacc_model_01_01 = addReaction(sacc_model_01_01,'DHQTi','3dhq_c <=> 3dhsk_c + h2o_c');
sacc_model_01_01 = addReaction(sacc_model_01_01,'PSCVT', 'pep_c + skm5p_c <=> 3psme_c + pi_c');
sacc_model_01_01 = addReaction(sacc_model_01_01,'CHORM', 'chor_c <=> pphn_c');
sacc_model_01_01 = addReaction(sacc_model_01_01,'TYRTAi', '34hpp_c + glu__L_c <=> akg_c + tyr__L_c');
sacc_model_01_01 = addReaction(sacc_model_01_01,'TYRTAim', '34hpp_m + glu__L_m <=> akg_m + tyr__L_m');
sacc_model_01_01 = addReaction(sacc_model_01_01,'TYRTAip', '34hpp_x + glu__L_x <=> akg_x + tyr__L_x');
sacc_model_01_01 = addReaction(sacc_model_01_01,'added_tyr__L_tym', 'tyr__L_c + h_c -> tym_c + co2_c');

% Finales
sacc_model_01_01 = addReaction(sacc_model_01_01,'added_tym_34dhbald_norcrg','tym_c + 34dhbald_c -> norcrg_c + h2o_c + h_c');
sacc_model_01_01 = addReaction(sacc_model_01_01,'added_norcrg_norbell','norcrg_c + nadph_c + h_c -> norbell_c + nadp_c');
sacc_model_01_01 = addReaction(sacc_model_01_01,'added_norbell_4omet','amet_c + norbell_c -> 4omet_c + ahcys_c + h_c');
sacc_model_01_01 = addReaction(sacc_model_01_01,'added_aux_4omet','4omet_c <=> 4omet_e');
sacc_model_01_01 = addReaction(sacc_model_01_01,'EX_4omet_e','4omet_e -> ');

% Cambiar funcion objetivo
sacc_model_01_01 = changeObjective(sacc_model_01_01,{'BIOMASS_SC5_notrace','EX_4omet_e'},[0.5,0.5]);

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
% 
% 3.2) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn <=> Largn -> tyr__L -> tym
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
% * tyr__L_c + h_c -> tym_c + co2_c     // No esta en modelo
%
% Reacciones finales
% 
% added_tym_34dhbald_norcrg
% * 34dhbald_c + tym_c -> norcrg_c + h2o_c + h_c
%
% added_norcrg_norbell
% * norcrg_c + nadph_c + h_c -> norbell_c + nadp_c
% 
% added_norbell_4omet
% * amet_c + norbell_c -> 4omet_c + ahcys_c + h_c
% 
% added_aux_4omet
%  * 4omet_c <=> 4omet_e
%
% EX_4omet_e
% * 4omet_e ->

% Agregar o modificar reacciones faltantes

% 2.1
sacc_model_01_02 = addReaction(sacc_model_b,'added_3dhsk_34dhbz','3dhsk_c -> 34dhbz_c + h2o_c');
sacc_model_01_02 = addReaction(sacc_model_01_02,'added_34dhbz_34dhbald','34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c');

% 3.2 
sacc_model_01_02 = addReaction(sacc_model_01_02,'DHQTi','3dhq_c <=> 3dhsk_c + h2o_c');
sacc_model_01_02 = addReaction(sacc_model_01_02,'PSCVT', 'pep_c + skm5p_c <=> 3psme_c + pi_c');
sacc_model_01_02 = addReaction(sacc_model_01_02,'CHORM', 'chor_c <=> pphn_c');
sacc_model_01_02 = addReaction(sacc_model_01_02,'added_pphn_Largn', 'pphn_c + glu__L_c <=> Largn_c + akg_c');
sacc_model_01_02 = addReaction(sacc_model_01_02,'added_pphn_Largn2', 'pphn_c + asp__L_c <=> Largn_c + oaa_c');
sacc_model_01_02 = addReaction(sacc_model_01_02,'added_Largn_tyr__L', 'Largn_c + nadp_c -> tyr__L_c + co2_c + nadph_c');
sacc_model_01_02 = addReaction(sacc_model_01_02,'added_Largn_tyr__L2', 'Largn_c + nad_c -> tyr__L_c + co2_c + nadh_c');
sacc_model_01_02 = addReaction(sacc_model_01_02,'added_tyr__L_tym', 'tyr__L_c + h_c -> tym_c + co2_c');

% Finales
sacc_model_01_02 = addReaction(sacc_model_01_02,'added_tym_34dhbald_norcrg','tym_c + 34dhbald_c -> norcrg_c + h2o_c + h_c');
sacc_model_01_02 = addReaction(sacc_model_01_02,'added_norcrg_norbell','norcrg_c + nadph_c + h_c -> norbell_c + nadp_c');
sacc_model_01_02 = addReaction(sacc_model_01_02,'added_norbell_4omet','amet_c + norbell_c -> 4omet_c + ahcys_c + h_c');
sacc_model_01_02 = addReaction(sacc_model_01_02,'added_aux_4omet','4omet_c <=> 4omet_e');
sacc_model_01_02 = addReaction(sacc_model_01_02,'EX_4omet_e','4omet_e -> ');

% Cambiar funcion objetivo
sacc_model_01_02 = changeObjective(sacc_model_01_02,{'BIOMASS_SC5_notrace','EX_4omet_e'},[0.5,0.5]);

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
% 
%  3.1) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn -> 34hpp <=> tyr__L -> tym
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
% * tyr__L_c + h_c -> tym_c + co2_c     // No esta en modelo
%
% Reacciones finales
% 
% added_tym_34dhbald_norcrg
% * 34dhbald_c + tym_c -> norcrg_c + h2o_c + h_c
%
% added_norcrg_norbell
% * norcrg_c + nadph_c + h_c -> norbell_c + nadp_c
% 
% added_norbell_4omet
% * amet_c + norbell_c -> 4omet_c + ahcys_c + h_c
% 
% added_aux_4omet
%  * 4omet_c <=> 4omet_e
%
% EX_4omet_e
% * 4omet_e ->

% Agregar o modificar reacciones faltantes

% 2.2
sacc_model_02_01 = addReaction(sacc_model_b,'added_4hbz_34dhbz','4hbz_c + nadph_c + o2_c + h_c -> 34dhbz_c + nadp_c + h2o_c');
sacc_model_02_01 = addReaction(sacc_model_02_01,'added_34dhbz_34dhbald','34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c');

% 3.1
sacc_model_02_01 = addReaction(sacc_model_02_01,'DHQTi','3dhq_c <=> 3dhsk_c + h2o_c');
sacc_model_02_01 = addReaction(sacc_model_02_01,'PSCVT', 'pep_c + skm5p_c <=> 3psme_c + pi_c');
sacc_model_02_01 = addReaction(sacc_model_02_01,'CHORM', 'chor_c <=> pphn_c');
sacc_model_02_01 = addReaction(sacc_model_02_01,'TYRTAi', '34hpp_c + glu__L_c <=> akg_c + tyr__L_c');
sacc_model_02_01 = addReaction(sacc_model_02_01,'TYRTAim', '34hpp_m + glu__L_m <=> akg_m + tyr__L_m');
sacc_model_02_01 = addReaction(sacc_model_02_01,'TYRTAip', '34hpp_x + glu__L_x <=> akg_x + tyr__L_x');
sacc_model_02_01 = addReaction(sacc_model_02_01,'added_tyr__L_tym', 'tyr__L_c + h_c -> tym_c + co2_c');

% Finales
sacc_model_02_01 = addReaction(sacc_model_02_01,'added_tym_34dhbald_norcrg','tym_c + 34dhbald_c -> norcrg_c + h2o_c + h_c');
sacc_model_02_01 = addReaction(sacc_model_02_01,'added_norcrg_norbell','norcrg_c + nadph_c + h_c -> norbell_c + nadp_c');
sacc_model_02_01 = addReaction(sacc_model_02_01,'added_norbell_4omet','amet_c + norbell_c -> 4omet_c + ahcys_c + h_c');
sacc_model_02_01 = addReaction(sacc_model_02_01,'added_aux_4omet','4omet_c <=> 4omet_e');
sacc_model_02_01 = addReaction(sacc_model_02_01,'EX_4omet_e','4omet_e -> ');

% Cambiar funcion objetivo
sacc_model_02_01 = changeObjective(sacc_model_02_01,{'BIOMASS_SC5_notrace','EX_4omet_e'},[0.5,0.5]);

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
% 
%  3.2) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn <=> Largn -> tyr__L -> tym
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
% * tyr__L_c + h_c -> tym_c + co2_c     // No esta en modelo
%
% Reacciones finales
% 
% added_tym_34dhbald_norcrg
% * 34dhbald_c + tym_c -> norcrg_c + h2o_c + h_c
%
% added_norcrg_norbell
% * norcrg_c + nadph_c + h_c -> norbell_c + nadp_c
% 
% added_norbell_4omet
% * amet_c + norbell_c -> 4omet_c + ahcys_c + h_c
% 
% added_aux_4omet
%  * 4omet_c <=> 4omet_e
%
% EX_4omet_e
% * 4omet_e ->

% Agregar o modificar reacciones faltantes

% 2.2
sacc_model_02_02 = addReaction(sacc_model_b,'added_4hbz_34dhbz','4hbz_c + nadph_c + o2_c + h_c -> 34dhbz_c + nadp_c + h2o_c');
sacc_model_02_02 = addReaction(sacc_model_02_02,'added_34dhbz_34dhbald','34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c');

% 3.2
sacc_model_02_02 = addReaction(sacc_model_02_02,'DHQTi','3dhq_c <=> 3dhsk_c + h2o_c');
sacc_model_02_02 = addReaction(sacc_model_02_02,'PSCVT', 'pep_c + skm5p_c <=> 3psme_c + pi_c');
sacc_model_02_02 = addReaction(sacc_model_02_02,'CHORM', 'chor_c <=> pphn_c');
sacc_model_02_02 = addReaction(sacc_model_02_02,'added_pphn_Largn', 'pphn_c + glu__L_c <=> Largn_c + akg_c');
sacc_model_02_02 = addReaction(sacc_model_02_02,'added_pphn_Largn2', 'pphn_c + asp__L_c <=> Largn_c + oaa_c');
sacc_model_02_02 = addReaction(sacc_model_02_02,'added_Largn_tyr__L', 'Largn_c + nadp_c -> tyr__L_c + co2_c + nadph_c');
sacc_model_02_02 = addReaction(sacc_model_02_02,'added_Largn_tyr__L2', 'Largn_c + nad_c -> tyr__L_c + co2_c + nadh_c');
sacc_model_02_02 = addReaction(sacc_model_02_02,'added_tyr__L_tym', 'tyr__L_c + h_c -> tym_c + co2_c');

% Finales
sacc_model_02_02 = addReaction(sacc_model_02_02,'added_tym_34dhbald_norcrg','tym_c + 34dhbald_c -> norcrg_c + h2o_c + h_c');
sacc_model_02_02 = addReaction(sacc_model_02_02,'added_norcrg_norbell','norcrg_c + nadph_c + h_c -> norbell_c + nadp_c');
sacc_model_02_02 = addReaction(sacc_model_02_02,'added_norbell_4omet','amet_c + norbell_c -> 4omet_c + ahcys_c + h_c');
sacc_model_02_02 = addReaction(sacc_model_02_02,'added_aux_4omet','4omet_c <=> 4omet_e');
sacc_model_02_02 = addReaction(sacc_model_02_02,'EX_4omet_e','4omet_e -> ');

% Cambiar funcion objetivo
sacc_model_02_02 = changeObjective(sacc_model_02_02,{'BIOMASS_SC5_notrace','EX_4omet_e'},[0.5,0.5]);

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
% 
% 3.1) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn -> 34hpp <=> tyr__L -> tym
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
% * tyr__L_c + h_c -> tym_c + co2_c     // No esta en modelo
%
% Reacciones finales
% 
% added_tym_34dhbald_norcrg
% * 34dhbald_c + tym_c -> norcrg_c + h2o_c + h_c
%
% added_norcrg_norbell
% * norcrg_c + nadph_c + h_c -> norbell_c + nadp_c
% 
% added_norbell_4omet
% * amet_c + norbell_c -> 4omet_c + ahcys_c + h_c
% 
% added_aux_4omet
%  * 4omet_c <=> 4omet_e
%
% EX_4omet_e
% * 4omet_e ->

% Agregar o modificar reacciones faltantes

% 2.3
sacc_model_03_01 = addReaction(sacc_model_b,'added_4hbz_4hbald','4hbz_c + atp_c + nadph_c + h_c <=> 4hbald_c + amp_c + nadp_c + ppi_c');
sacc_model_03_01 = addReaction(sacc_model_03_01,'added_4hbald_34dhbald','4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c');

% 3.1
sacc_model_03_01 = addReaction(sacc_model_03_01,'DHQTi','3dhq_c <=> 3dhsk_c + h2o_c');
sacc_model_03_01 = addReaction(sacc_model_03_01,'PSCVT', 'pep_c + skm5p_c <=> 3psme_c + pi_c');
sacc_model_03_01 = addReaction(sacc_model_03_01,'CHORM', 'chor_c <=> pphn_c');
sacc_model_03_01 = addReaction(sacc_model_03_01,'TYRTAi', '34hpp_c + glu__L_c <=> akg_c + tyr__L_c');
sacc_model_03_01 = addReaction(sacc_model_03_01,'TYRTAim', '34hpp_m + glu__L_m <=> akg_m + tyr__L_m');
sacc_model_03_01 = addReaction(sacc_model_03_01,'TYRTAip', '34hpp_x + glu__L_x <=> akg_x + tyr__L_x');
sacc_model_03_01 = addReaction(sacc_model_03_01,'added_tyr__L_tym', 'tyr__L_c + h_c -> tym_c + co2_c');

% Finales
sacc_model_03_01 = addReaction(sacc_model_03_01,'added_tym_34dhbald_norcrg','tym_c + 34dhbald_c -> norcrg_c + h2o_c + h_c');
sacc_model_03_01 = addReaction(sacc_model_03_01,'added_norcrg_norbell','norcrg_c + nadph_c + h_c -> norbell_c + nadp_c');
sacc_model_03_01 = addReaction(sacc_model_03_01,'added_norbell_4omet','amet_c + norbell_c -> 4omet_c + ahcys_c + h_c');
sacc_model_03_01 = addReaction(sacc_model_03_01,'added_aux_4omet','4omet_c <=> 4omet_e');
sacc_model_03_01 = addReaction(sacc_model_03_01,'EX_4omet_e','4omet_e -> ');
% Cambiar funcion objetivo
sacc_model_03_01 = changeObjective(sacc_model_03_01,{'BIOMASS_SC5_notrace','EX_4omet_e'},[0.5,0.5]);

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
% 
% 3.2) 2dda7p -> 3dhq <=> 3dhsk <=> skm -> skm3p <=> 3psme -> chor <=> pphn <=> Largn -> tyr__L -> tym
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
% * tyr__L_c + h_c -> tym_c + co2_c     // No esta en modelo
%
% Reacciones finales
% 
% added_tym_34dhbald_norcrg
% * 34dhbald_c + tym_c -> norcrg_c + h2o_c + h_c
%
% added_norcrg_norbell
% * norcrg_c + nadph_c + h_c -> norbell_c + nadp_c
% 
% added_norbell_4omet
% * amet_c + norbell_c -> 4omet_c + ahcys_c + h_c
% 
% added_aux_4omet
%  * 4omet_c <=> 4omet_e
%
% EX_4omet_e
% * 4omet_e ->

% Agregar o modificar reacciones faltantes

% 2.3
sacc_model_03_02 = addReaction(sacc_model_b,'added_4hbz_4hbald','4hbz_c + atp_c + nadph_c + h_c <=> 4hbald_c + amp_c + nadp_c + ppi_c');
sacc_model_03_02 = addReaction(sacc_model_03_02,'added_4hbald_34dhbald','4hbald_c + nadph_c + o2_c + h_c -> 34dhbald_c + nadp_c + h2o_c');

% 3.2
sacc_model_03_02 = addReaction(sacc_model_03_02,'DHQTi','3dhq_c <=> 3dhsk_c + h2o_c');
sacc_model_03_02 = addReaction(sacc_model_03_02,'PSCVT', 'pep_c + skm5p_c <=> 3psme_c + pi_c');
sacc_model_03_02 = addReaction(sacc_model_03_02,'CHORM', 'chor_c <=> pphn_c');
sacc_model_03_02 = addReaction(sacc_model_03_02,'added_pphn_Largn', 'pphn_c + glu__L_c <=> Largn_c + akg_c');
sacc_model_03_02 = addReaction(sacc_model_03_02,'added_pphn_Largn2', 'pphn_c + asp__L_c <=> Largn_c + oaa_c');
sacc_model_03_02 = addReaction(sacc_model_03_02,'added_Largn_tyr__L', 'Largn_c + nadp_c -> tyr__L_c + co2_c + nadph_c');
sacc_model_03_02 = addReaction(sacc_model_03_02,'added_Largn_tyr__L2', 'Largn_c + nad_c -> tyr__L_c + co2_c + nadh_c');
sacc_model_03_02 = addReaction(sacc_model_03_02,'added_tyr__L_tym', 'tyr__L_c + h_c -> tym_c + co2_c');

% Finales
sacc_model_03_02 = addReaction(sacc_model_03_02,'added_tym_34dhbald_norcrg','tym_c + 34dhbald_c -> norcrg_c + h2o_c + h_c');
sacc_model_03_02 = addReaction(sacc_model_03_02,'added_norcrg_norbell','norcrg_c + nadph_c + h_c -> norbell_c + nadp_c');
sacc_model_03_02 = addReaction(sacc_model_03_02,'added_norbell_4omet','amet_c + norbell_c -> 4omet_c + ahcys_c + h_c');
sacc_model_03_02 = addReaction(sacc_model_03_02,'added_aux_4omet','4omet_c <=> 4omet_e');
sacc_model_03_02 = addReaction(sacc_model_03_02,'EX_4omet_e','4omet_e -> ');

% Cambiar funcion objetivo
sacc_model_03_02 = changeObjective(sacc_model_03_02,{'BIOMASS_SC5_notrace','EX_4omet_e'},[0.5,0.5]);

% FBA
FBAsolution_03_02 = optimizeCbModel(sacc_model_03_02,'max');
F_03_02 = FBAsolution_03_02.f;