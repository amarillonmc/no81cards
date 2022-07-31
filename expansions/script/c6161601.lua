--虚无世界 最终之梦
function c6161601.initial_effect(c)
	 --special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,6161601)   
	e1:SetTarget(c6161601.target)  
	e1:SetOperation(c6161601.operation)  
	c:RegisterEffect(e1)
	 --act in hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	e2:SetCondition(c6161601.handcon)  
	c:RegisterEffect(e2)	
end
function c6161601.spfilter(c,e,tp)  
	return c:IsSetCard(0x616) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c6161601.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(c6161601.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function c6161601.operation(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c6161601.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)   
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_FIELD)  
		e1:SetRange(LOCATION_MZONE)  
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
		e1:SetAbsoluteRange(tp,1,0)  
		e1:SetTarget(c6161601.splimit)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		g:GetFirst():RegisterEffect(e1,true)  
	end 
end
function c6161601.splimit(e,c)
	return not c:IsRace(RACE_SPELLCASTER)
end 
function c6161601.handcon(e)  
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0  
end  