--破碎世界的太阳
function c6161301.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,c6161301.mfilter,3,2,c6161301.ovfilter,aux.Stringid(6161301,0))  
	c:EnableReviveLimit()  
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6161301,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,6161301)
	e1:SetCost(c6161301.spcost)
	e1:SetTarget(c6161301.sptg)
	e1:SetOperation(c6161301.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(6161301,1))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,6161301)  
	e2:SetCondition(aux.exccon)  
	e2:SetCost(aux.bfgcost)  
	e2:SetTarget(c6161301.thtg)  
	e2:SetOperation(c6161301.thop)  
	c:RegisterEffect(e2)   
end
function c6161301.mfilter(c)  
	return c:IsRace(RACE_SPELLCASTER)
end  
function c6161301.ovfilter(c)  
	return c:IsFaceup() and c:IsCode(6160202)
end 
function c6161301.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)   
end
function c6161301.afilter(c,e,tp)  
	return c:IsSetCard(0x616) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end  
function c6161301.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0   
		and Duel.IsExistingMatchingCard(c6161301.afilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)  
end  
function c6161301.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c6161301.afilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then 
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)		 
end  
end
function c6161301.thfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x616) and c:IsAbleToHand() 
end
function c6161301.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c6161301.hdfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c6161301.thfilter,tp,LOCATION_REMOVED,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local sg=Duel.SelectTarget(tp,c6161301.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)  
end  
function c6161301.thop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end  
end  