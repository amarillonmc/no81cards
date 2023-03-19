--最强之龙的神降
function c11513046.initial_effect(c)
	aux.AddCodeList(c,11513043)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,11513046) 
	e1:SetCost(c11513046.accost)
	e1:SetTarget(c11513046.actg) 
	e1:SetOperation(c11513046.acop) 
	c:RegisterEffect(e1)  
	--token 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED) 
	e2:SetCountLimit(1,21513046)   
	e2:SetCondition(aux.exccon)
	e2:SetCost(c11513046.tkcost)
	e2:SetTarget(c11513046.tktg) 
	e2:SetOperation(c11513046.tkop) 
	c:RegisterEffect(e2)
	--Duel.AddCustomActivityCounter(11513046,ACTIVITY_SPSUMMON,c11513046.counterfilter)
end
function c11513046.counterfilter(c)
	return c:IsType(TYPE_RITUAL)
end
function c11513046.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end 
function c11513046.spfil(c,e,tp) 
	return c:IsCode(11513043) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)  
end 
function c11513046.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil) and Duel.IsExistingMatchingCard(c11513046.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,2,0,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end 
function c11513046.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil) 
	local g3=Duel.GetMatchingGroup(c11513046.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 then 
	local tc=g3:Select(tp,1,1,nil):GetFirst()
	local rg1=g1:RandomSelect(tp,1) 
	local rg2=g2:RandomSelect(tp,1) 
	rg1:Merge(rg2) 
	tc:SetMaterial(rg1) 
	Duel.SendtoGrave(rg1,REASON_COST) 
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) 
	tc:CompleteProcedure() 
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCountLimit(1)
		e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) end)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3,true)
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11513046.splimit)
	Duel.RegisterEffect(e1,tp) 
end 
function c11513046.splimit(e,c)
	return not c:IsType(TYPE_RITUAL)
end 
function c11513046.xctfil(c,tp) 
	return c:IsAbleToDeckAsCost() and c:IsCode(11513043) 
end 
function c11513046.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c11513046.xctfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),tp) end 
	local g=Duel.SelectMatchingCard(tp,c11513046.xctfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler(),tp)
	g:AddCard(e:GetHandler()) 
	Duel.SendtoDeck(g,nil,2,REASON_COST) 
end 
function c11513046.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and Duel.IsPlayerCanSpecialSummonMonster(tp,11513047,0,TYPES_TOKEN_MONSTER,2000,0,6,RACE_DRAGON,ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_EXTRA,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c11513046.tkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,nil) 
	local rg=g:RandomSelect(tp,1) 
	if Duel.SendtoGrave(rg,REASON_EFFECT)==0 then return end 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,11513047,0,TYPES_TOKEN_MONSTER,2000,0,6,RACE_DRAGON,ATTRIBUTE_LIGHT) then return end 
		local token1=Duel.CreateToken(tp,11513047) 
		local token2=Duel.CreateToken(tp,11513047)
		local sg=Group.FromCards(token1,token2) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
		local token=sg:GetFirst() 
	while token do   
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE) 
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(TYPE_RITUAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL) 
		e2:SetValue(function(e,c,sumtype)
		return sumtype==SUMMON_TYPE_FUSION end) 
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2)   
		token=sg:GetNext()
	end  
		sg:KeepAlive()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE) 
		e3:SetCountLimit(1) 
		e3:SetLabelObject(sg)
		e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Destroy(e:GetLabelObject(),REASON_EFFECT) end)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp) 
end








