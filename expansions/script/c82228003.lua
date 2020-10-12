function c82228003.initial_effect(c)  
	--special summon
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228003,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,82228003) 
	e1:SetCondition(c82228003.spcon)  
	e1:SetTarget(c82228003.sptg)  
	e1:SetOperation(c82228003.spop)  
	c:RegisterEffect(e1)  
	--pierce
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e2)
end  

function c82228003.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x290)  
end  

function c82228003.spfilter(c,e,tp)  
	return c:IsSetCard(0x290) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)  
end  
 
function c82228003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(c82228003.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
 
function c82228003.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228003.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)  
	end  
end  