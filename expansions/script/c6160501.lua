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
	e1:SetTarget(c6160501.sptg)
	e1:SetOperation(c6160501.spop)
	c:RegisterEffect(e1)	
end
function c6160501.filter(c,e,tp)
	return c:IsSetCard(0x616) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c6160501.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0   
		and Duel.IsExistingMatchingCard(c6160501.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)  
end  
function c6160501.spop(e,tp,eg,ep,ev,re,r,rp) 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c6160501.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  