--后启示录 神灭篇章
local m = 33310509
local cm= _G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--instant
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCost(cm.sumcost)
	e2:SetTarget(cm.sumtg)
	e2:SetOperation(cm.sumop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
end
function cm.cfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeckAsCost()
end
function cm.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function cm.sumfilter(c)
	return c:IsSetCard(0x55d) and c:IsSummonable(true,nil)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and not c:IsSetCard(0x55d)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g<=0 then return end
	local tc,tc2
	local ct = 0
	::TOG::
	g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g>0 then
		tc =  g:GetMinGroup(Card.GetSequence):GetFirst()
		Duel.SendtoGrave(tc,REASON_EFFECT)
		tc2 = Duel.GetOperatedGroup():GetFirst()
		if tc2 and tc2:IsLocation(LOCATION_GRAVE) then
			ct = ct + 1
		end
		if tc2 and tc2:IsSetCard(0x55d) then
			goto TOG
		end
	end
	Duel.BreakEffect()
	if ct >0 then
		Duel.Damage(1-tp,ct*666,REASON_EFFECT)
	end
end