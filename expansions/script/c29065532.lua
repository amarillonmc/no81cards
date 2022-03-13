--方舟骑士源石秘仪
c29065532.named_with_Arknight=1
function c29065532.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065532,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c29065532.cost)
	e1:SetTarget(c29065532.target)
	e1:SetOperation(c29065532.operation)
	c:RegisterEffect(e1)
end
function c29065532.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c29065532.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsRace(RACE_SPELLCASTER) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))  and c:IsAbleToHand()
end
function c29065532.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065532.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065532.spfil(c)  
	return c:IsRace(RACE_SPELLCASTER) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29065532.spfil1(c,e,tp)  
	return c:IsRace(RACE_SPELLCASTER) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and Duel.GetMZoneCount(tp)>0
end
function c29065532.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c29065532.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	local mg=Duel.GetRitualMaterial(tp)
	if (Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c29065532.spfil,e,tp,mg,nil,Card.GetLevel,"Greater") or (Duel.IsExistingMatchingCard(c29065532.spfil1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsCanRemoveCounter(tp,1,0,0x10ae,3,REASON_COST))) and Duel.SelectYesNo(tp,aux.Stringid(29065532,0)) then  
	if (Duel.IsExistingMatchingCard(c29065532.spfil1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsCanRemoveCounter(tp,1,0,0x10ae,3,REASON_COST)) and Duel.SelectYesNo(tp,aux.Stringid(29065532,1)) then
	Duel.RemoveCounter(tp,1,0,0x10ae,3,REASON_COST) 
	local tc=Duel.SelectMatchingCard(tp,c29065532.spfil1,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst() 
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	tc:CompleteProcedure()  
	else 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,c29065532.spfil,e,tp,mg,nil,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()  
	end
	end
	end
end
end
