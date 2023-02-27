function [final_model] = addFixedRxns(model, tym_route)
%   Estas reacciones ya estan en el modelo, se estraba probando en doble sentido
%   final_model = addReaction(model,'DHQTi','3dhq_c -> 3dhsk_c + h2o_c');
%   final_model = addReaction(final_model,'PSCVT', 'pep_c + skm5p_c -> 3psme_c + pi_c');
%   final_model = addReaction(final_model,'CHORM', 'chor_c -> pphn_c'); 

    if tym_route=='1' % 3-(4-Hydroxyphenyl)pyruvate
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
%       Estas reacciones ya estan en el modelo, se estraba probando en doble sentido
%       final_model = addReaction(final_model,'TYRTAi', '34hpp_c + glu__L_c -> akg_c + tyr__L_c'); 
%       final_model = addReaction(final_model,'TYRTAim', '34hpp_m + glu__L_m -> akg_m + tyr__L_m'); 
%       final_model = addReaction(final_model,'TYRTAip', '34hpp_x + glu__L_x -> akg_x + tyr__L_x'); 

        final_model = addReaction(model,'added_tyr__L_tym', 'tyr__L_c + h_c -> tym_c + co2_c');
    else % L-Arogenate
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

        final_model = addReaction(model,'added_pphn_Largn', 'pphn_c + glu__L_c <=> Largn_c + akg_c');
        final_model = addReaction(final_model,'added_Largn_tyr__L', 'Largn_c + nadp_c -> tyr__L_c + co2_c + nadph_c');
        final_model = addReaction(final_model,'added_tyr__L_tym', 'tyr__L_c + h_c -> tym_c + co2_c');
    end

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
    final_model = addReaction(final_model,'added_tym_34dhbald_norcrg','tym_c + 34dhbald_c -> norcrg_c + h2o_c + h_c');
    final_model = addReaction(final_model,'added_norcrg_norbell','norcrg_c + nadph_c + h_c -> norbell_c + nadp_c');
    final_model = addReaction(final_model,'added_norbell_4omet','amet_c + norbell_c -> 4omet_c + ahcys_c + h_c');
    final_model = addReaction(final_model,'added_aux_4omet','4omet_c <=> 4omet_e');
    final_model = addReaction(final_model,'EX_4omet_e','4omet_e -> ');
    
    %final_model = addReaction(final_model, 'added_fadh2','fadh2_m <=> fadh2_c');

    % Cambiar funcion objetivo
    final_model = changeObjective(final_model,{'BIOMASS_SC5_notrace','EX_4omet_e'},[0.5,0.5]);
    %final_model = changeObjective(final_model,{'EX_4omet_e'});
    %final_model = changeObjective(final_model,{'BIOMASS_SC5_notrace'});
end

