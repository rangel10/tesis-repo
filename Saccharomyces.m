% Saccharomyces cerevisiae

sacc_model = readCbModel('iMM904.mat');
printObjective(sacc_model)
%outmodel = writeCbModel(sacc_model, 'xls','sacc_model.xls');
sacc_model_a = changeRxnBounds(sacc_model, 'EX_glu__L_e',-100,'l');
sacc_model_a = changeRxnBounds(sacc_model_a,'EX_o2_e',-1000,'l');
%outmodel = writeCbModel(sacc_model_a, 'xls','sacc_model_a.xls');

tyrosineSubystem = {'S_Tyrosine__Tryptophan__and_Phenylalanine_Metabolism'};
tyrosineReactions = sacc_model_a.rxns(ismember(sacc_model_a.subSystems,tyrosineSubystem));
[~,tyrosine_rxnID] = ismember(tyrosineReactions,sacc_model_a.rxns);
Reaction_Names = sacc_model_a.rxnNames(tyrosine_rxnID);
Reaction_Formulas = printRxnFormula(sacc_model_a,tyrosineReactions,0);

T = table(Reaction_Names,Reaction_Formulas,'RowNames',tyrosineReactions)

FBAsolution = optimizeCbModel(sacc_model_a,'max');

Tyrosine_Flux = FBAsolution.x(tyrosine_rxnID);
T = table(Tyrosine_Flux,'RowNames',tyrosineReactions)