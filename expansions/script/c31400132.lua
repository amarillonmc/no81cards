local m=31400132
local cm=_G["c"..m]
cm.name="一灵降临"
function cm.initial_effect(c)
	aux.EnableChangeCode(c,11167052,LOCATION_DECK)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(cm.intg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.tgcost)
	e4:SetTarget(cm.tgtg)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetCost(cm.spcost)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
end
function cm.intg(e,c)
	return c:IsFaceup() and c:IsCode(61557074)
end
function cm.cfilter(c)
	return c:IsCode(61557074) and c:IsAbleToDeckAsCost() and c:IsFaceup()
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and c:IsAbleToDeckAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.tgfilter(c)
	return c:IsSetCard(0x400d) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil)
	if #g<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	aux.GCheckAdditional=aux.dncheck
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,1,#g)
	aux.GCheckAdditional=nil
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.sptdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x113) and c:IsAbleToDeck()
end
function cm.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sptdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local c=Duel.SelectMatchingCard(tp,cm.sptdfilter,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
	local code=c:GetCode()
	if c and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,code) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end