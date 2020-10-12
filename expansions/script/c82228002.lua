function c82228002.initial_effect(c)  
	--revive 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetTarget(c82228002.target)  
	e1:SetCountLimit(1,82228002)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetOperation(c82228002.operation)  
	e1:SetRange(LOCATION_GRAVE) 
	c:RegisterEffect(e1)	
	--special summon  
	local e2=Effect.CreateEffect(c)   
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetHintTiming(0,TIMING_END_PHASE) 
	e2:SetCost(c82228002.spcost)  
	e2:SetTarget(c82228002.sptg)  
	e2:SetOperation(c82228002.spop)  
	c:RegisterEffect(e2) 
end  

function c82228002.tgfilter(c,tp)  
	return c:IsFaceup() and c:IsSetCard(0x290) and c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)  
end  

function c82228002.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c82228002.tgfilter(chkc,tp) end  
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)  
		and Duel.IsExistingTarget(c82228002.tgfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)  
	local g=Duel.SelectTarget(tp,c82228002.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)   
end  

function c82228002.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then 
		if tc:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SendtoHand(tc,nil,REASON_EFFECT) 
		end
	end  
end  

function c82228002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsReleasable() end  
	Duel.Release(e:GetHandler(),REASON_COST)  
end  

function c82228002.spfilter(c,e,tp)  
	return c:IsCode(82228003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  

function c82228002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1  
		and Duel.IsExistingMatchingCard(c82228002.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)  
end  

function c82228002.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228002.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  