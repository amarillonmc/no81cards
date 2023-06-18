--末那愚子族型俱舍怒威族
function c11561000.initial_effect(c)
	--SpecialSummon and remove 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,11561000)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end) 
	e1:SetTarget(c11561000.sprtg) 
	e1:SetOperation(c11561000.sprop) 
	c:RegisterEffect(e1) 
	--des 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,21561000) 
	e2:SetTarget(c11561000.destg) 
	e2:SetOperation(c11561000.desop) 
	c:RegisterEffect(e2) 
	--sp 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_DESTROYED) 
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,31561000) 
	e3:SetCondition(function(e) 
	return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE) end)
	e3:SetTarget(c11561000.sptg) 
	e3:SetOperation(c11561000.spop) 
	c:RegisterEffect(e3)  
end 
function c11561000.rmfil(c) 
	return c:IsSetCard(0x189,0x190) and c:IsAbleToRemove() 
end 
function c11561000.sprtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c11561000.rmfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end 
function c11561000.sprop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(c11561000.rmfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) then 
		local rg=Duel.SelectMatchingCard(tp,c11561000.rmfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil) 
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)   
	end 
end 
function c11561000.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0x189,0x190) end,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE) 
end 
function c11561000.desop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsSetCard(0x189,0x190) end,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,1,nil) 
		Duel.Destroy(dg,REASON_EFFECT)  
	end 
end 
function c11561000.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(11561000)   
end 
function c11561000.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11561000.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	e:SetLabel(Duel.AnnounceLevel(tp,1,6))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end 
function c11561000.spop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local lv=e:GetLabel() 
	local g=Duel.GetMatchingGroup(c11561000.spfil,tp,LOCATION_DECK,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
		if Duel.IsExistingMatchingCard(function(c,lv) return c:IsFaceup() and c:IsSetCard(0x189,0x190) and not c:IsLevel(lv) end,tp,LOCATION_MZONE,0,1,nil,lv) and Duel.SelectYesNo(tp,aux.Stringid(11561000,0)) then 
			Duel.BreakEffect() 
			local tc=Duel.SelectMatchingCard(tp,function(c,lv) return c:IsFaceup() and c:IsSetCard(0x189,0x190) and not c:IsLevel(lv) end,tp,LOCATION_MZONE,0,1,1,nil,lv):GetFirst() 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(e:GetLabel())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)  
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_TUNER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end 
	end 
end 




 


