local m=82209000
local cm=_G["c"..m]
--低等征龙
function cm.initial_effect(c)
		--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)  
	e1:SetCost(cm.hspcost)  
	e1:SetTarget(cm.hsptg)  
	e1:SetOperation(cm.hspop)  
	c:RegisterEffect(e1)  
end
function cm.rfilter(c)  
	return c:IsAbleToRemoveAsCost()  
end  
function cm.rfilter2(c)  
	return not c:IsAbleToRemoveAsCost()  
end  
function cm.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,c) and not Duel.IsExistingMatchingCard(cm.rfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)  
end  
function cm.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.hspop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
end  