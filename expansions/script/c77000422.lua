--邪心英雄 戮杀翼魔
function c77000422.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c77000422.spcon)
	e2:SetTarget(c77000422.sptg)
	e2:SetOperation(c77000422.spop)
	c:RegisterEffect(e2)
end
function c77000422.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r&REASON_FUSION~=0 
end 
function c77000422.espfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsCode(22160245) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end 
function c77000422.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77000422.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end 
function c77000422.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c77000422.espfil,tp,LOCATION_EXTRA,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP) 
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCountLimit(1)
		e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) end)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		sc:RegisterEffect(e3,true)
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c77000422.splimit) 
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c77000422.splimit(e,c)
	return not c:IsRace(RACE_FIEND) 
end






