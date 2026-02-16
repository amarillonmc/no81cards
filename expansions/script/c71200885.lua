--绝音魔女·断罪之白雪
function c71200885.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_ZOMBIE),1)
	c:EnableReviveLimit()
	--synchro level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SYNCHRO_LEVEL)
	e1:SetLabelObject(c)
	e1:SetValue(c71200885.slevel)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(function(e,c) 
	return c:IsRace(RACE_BEAST) and c:IsLevel(1) and c:IsType(TYPE_TUNER) end)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--dis 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c71200885.distg)
	e1:SetOperation(c71200885.disop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(function(e,c) 
	return c:IsSetCard(0x895) end)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCondition(function(e) 
	return e:GetHandler():IsReason(REASON_EFFECT) end)
	e3:SetTarget(c71200885.rstg)
	e3:SetOperation(c71200885.rsop)
	c:RegisterEffect(e3)
end
function c71200885.slevel(e,c) 
	local lv=aux.GetCappedLevel(e:GetHandler())
	if c==e:GetLabelObject() then  
		return (3<<16)+lv 
	else 
		return lv
	end 
end
function c71200885.ctfil(c) 
	return c:IsSetCard(0x895) and c:IsAbleToGraveAsCost()  
end 
function c71200885.discost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c71200885.ctfil,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.dncheck,2,2) end 
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2) 
	Duel.SendtoGrave(sg,REASON_COST)
end 
function c71200885.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0) 
end
function c71200885.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end 
end
function c71200885.rstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1400)
end
function c71200885.rsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.Recover(tp,1400,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(71200885,0)) then 
		Duel.BreakEffect()
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD) 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end 


