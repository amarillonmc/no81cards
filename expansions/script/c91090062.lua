--魊影宙海的痕裂
local m=91090062
local cm=c91090062
function c91090062.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(cm.setcost)
	e3:SetTarget(cm.settg)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
end
function cm.cfilter1(c)
	return  c:IsSetCard(0x18a) and c:IsAbleToDeckAsCost() 
end
function cm.cfilter2(c)
	return  c:IsRace(RACE_FISH) and c:IsAbleToDeckOrExtraAsCost() and c:IsType(TYPE_SYNCHRO)
end
function cm.fselect(sg)
	if #sg==1 then
		return (sg:GetFirst():IsRace(RACE_FISH) and sg:GetFirst():IsType(TYPE_SYNCHRO))
	else
		return (sg:GetFirst():IsSetCard(0x18a)) and (sg:GetNext():IsSetCard(0x18a))
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) or Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.cfilter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.cfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g1<=1 and #g2==0 then return end
	if #g1>0 then
	g:Merge(g1) end
	if #g2>0 then
	g:Merge(g2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g3=g:SelectSubGroup(tp,cm.fselect,false,1,2)
	Duel.SendtoDeck(g3,nil,SEQ_DECKBOTTOM,REASON_COST)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.costfilter(c)
	return c:IsRace(RACE_FISH)  and c:IsAbleToGraveAsCost()
end
function cm.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e1)
	end
end