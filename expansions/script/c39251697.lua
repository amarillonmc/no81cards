--电子龙核
local m=39251697
local cm=_G["c"..m]
function cm.initial_effect(c)
	--code
	aux.EnableChangeCode(c,70095154,LOCATION_MZONE+LOCATION_GRAVE)
	--special summon 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spco)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1093) and not c:IsCode(m)
end
function cm.disfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1093)
end
function cm.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=e:GetHandler()
	local b=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_HAND,0,1,nil):GetFirst()
	if chk==0 then return a:IsLocation(LOCATION_GRAVE)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsAbleToRemoveAsCost() 
	and Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_HAND,0,1,nil)
	and b:IsDiscardable() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,cm.disfilter,1,1,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
