local m=60001084
local cm=_G["c"..m]
cm.name="闪刀术式-神灭"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:GetSequence()<5
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.rmfilter(c,e,tp)
	local loc1=c:GetLocation()
	if bit.band(c:GetLocation(),LOCATION_ONFIELD)~=0 then loc1=LOCATION_ONFIELD end
	return c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_EFFECT) and Duel.IsExistingMatchingCard(cm.rmmefilter,tp,loc1,0,2,e:GetHandler(),tp,loc1)
end
function cm.rmmefilter(c,tp,loc1)
	return c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_EFFECT) and bit.band(c:GetLocation(),loc1)~=0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ablerm_hand=0
	local ablerm_deck=0
	local ablerm_extra=0
	local ablerm_gyonfield=0
	if Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_HAND,1,nil,tp) then ablerm_hand=1 end
	if Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_DECK,1,nil,tp) then ablerm_deck=1 end
	if Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_EXTRA,1,nil,tp) then ablerm_extra=1 end
	if Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil,tp) then ablerm_gyonfield=1 end
	local list={}
	if ablerm_hand==1 then table.insert(list,aux.Stringid(m,2)) else table.insert(list,aux.Stringid(m,6)) end
	if ablerm_deck==1 then table.insert(list,aux.Stringid(m,3)) else table.insert(list,aux.Stringid(m,6)) end
	if ablerm_gyonfield==1 then table.insert(list,aux.Stringid(m,4)) else table.insert(list,aux.Stringid(m,6)) end
	if ablerm_extra==1 then table.insert(list,aux.Stringid(m,5)) else table.insert(list,aux.Stringid(m,6)) end
	local i=0
	local x=0
	while i==0 do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		x=Duel.SelectOption(tp,table.unpack(list))
		if x==0 and ablerm_hand~=0 then i=1 end
		if x==1 and ablerm_deck~=0 then i=1 end
		if x==2 and ablerm_gyonfield~=0 then i=1 end
		if x==3 and ablerm_extra~=0 then i=1 end
	end
	local loc=0
	if x==0 then loc=LOCATION_HAND end
	if x==1 then loc=LOCATION_DECK end
	if x==2 then loc=LOCATION_GRAVE+LOCATION_ONFIELD end
	if x==3 then loc=LOCATION_EXTRA end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,loc,nil,tp)
	local ag=Group.CreateGroup()
	if x==0 or x==1 or x==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		ag=g:RandomSelect(tp,1)
	elseif x==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		ag=g:Select(tp,1,1,nil)
	end
	local bg=Group.CreateGroup()
	local loc2=ag:GetFirst():GetLocation()
	if bit.band(loc2,LOCATION_ONFIELD)~=0 then loc2=LOCATION_ONFIELD end
	if ag:GetCount()~=0 and Duel.Remove(ag,POS_FACEDOWN,REASON_EFFECT)~=0 then
		bg=Duel.GetOperatedGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local wg=Duel.SelectMatchingCard(tp,cm.rmmefilter,tp,loc2,0,2,2,e:GetHandler(),tp,loc2)
		if wg:GetCount()~=0 and Duel.Remove(wg,POS_FACEDOWN,REASON_EFFECT)~=0 and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 and bg:GetCount()~=0 and bg:GetFirst():IsAbleToHand(tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.SendtoHand(bg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,bg)
		end
	end
end