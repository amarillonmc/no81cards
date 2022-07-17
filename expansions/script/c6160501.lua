--
function c6160501.initial_effect(c)
	--activae
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6160501,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,6160501)
	e1:SetTarget(c6160501.target)
	e1:SetOperation(c6160501.activate)
	c:RegisterEffect(e1)	
end
function c6160501.spfilter(c,e,tp)
	return c:IsSetCard(0x616) and c:IsType(TYPE_MONSTER)
end
function c6160501.target(e,tp,eg,ep,ev,re,e,ep,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c6160501.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c6160501.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c6160501.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_FIELD)  
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
		e1:SetTargetRange(1,0)  
		e1:SetTarget(c6160501.splimit)  
		e1:SetReset(RESET_PHASE+PHASE_END)  
		Duel.RegisterEffect(e1,tp)  
	end  
end  
function c6160501.splimit(e,c)  
	return not c:IsRace(RACE_SPELLCASTER)  
end  