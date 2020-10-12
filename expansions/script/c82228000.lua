function c82228000.initial_effect(c)  
	--send to grave  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SUMMON_SUCCESS)  
	e1:SetTarget(c82228000.target)  
	e1:SetCountLimit(1,82228000)
	e1:SetOperation(c82228000.operation)  
	c:RegisterEffect(e1)	
	local e2=e1:Clone()  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e2)  
	--special summon  
	local e3=Effect.CreateEffect(c)   
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetHintTiming(0,TIMING_END_PHASE) 
	e3:SetCost(c82228000.spcost)  
	e3:SetTarget(c82228000.sptg)  
	e3:SetOperation(c82228000.spop)  
	c:RegisterEffect(e3) 
end  

function c82228000.tgfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x290) and c:IsAbleToGrave()  
end  

function c82228000.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228000.tgfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)  
end  

function c82228000.operation(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,c82228000.tgfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoGrave(g,REASON_EFFECT)  
	end  
end  
 
function c82228000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsReleasable() end  
	Duel.Release(e:GetHandler(),REASON_COST)  
end  

function c82228000.spfilter(c,e,tp)  
	return c:IsCode(82228001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  

function c82228000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1  
		and Duel.IsExistingMatchingCard(c82228000.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)  
end  

function c82228000.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228000.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  