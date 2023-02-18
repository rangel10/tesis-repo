% Saccharomyces cerevisiae

% Leer modelo
sacc_model = readCbModel('iMM904.mat');
printObjective(sacc_model)

% exportar xls de modelo base
% outmodel = writeCbModel(sacc_model, 'xls','sacc_model.xls');

% condiciones iniciales: -100 glucosa y -1000 oxigeno
sacc_model_i = changeRxnBounds(sacc_model, 'EX_glc__D_e',-100,'l');
sacc_model_i = changeRxnBounds(sacc_model_i,'EX_o2_e',-1000,'l');

% Exportar xls de modelo con condiciones iniciales
% outmodel = writeCbModel(sacc_model_a, 'xls','sacc_model_a.xls');


% Analisis modelo base con condiciones iniciales
checkObjective(sacc_model_i)

FBAsolution = optimizeCbModel(sacc_model_i,'max');
FBAsolution.f

% Analisis para ruta 2.1/3.1 - 01_01

% 2dda7p -> 3dhq <=> 3dhsk -> 34dhbz <=> 34dhbald
% 
% * 2dda7p_c -> 3dhq_c + pi_c
% * 3dhq_c <=> 3dhsk_c + h2o_c     // ->
% * 3dhsk_c -> 34dhbz_c + h2o_c     // No esta en modelo
% * 34dhbz_c + atp_c + nadph_c + h_c <=> 34dhbald_c + amp_c + nadp_c + ppi_c     // No esta en modelo (?)

% Agregar o modificar reaccioens faltantes
sacc_model_01_01 = addReaction(sacc_model_i,'DHQTi','3dhq_c <=> 3dhsk_c + h2o_c');

% Cambiar funcion objetivo
%changeObjective()

% FBA
FBAsolution_01_01 = 0;

