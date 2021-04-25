--冥散华·消逝的太阳
local m=33701436
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil,POS_FACEDOWN)
	local opt=0
	if g:GetCount()==Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) then
		opt=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	if opt==0 then Duel.SetLP(tp,Duel.GetLP(tp)-8000)
	else
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
	if Duel.GetLP(tp)>0 and Duel.GetActivityCount(1-tp,ACTIVITY_CHAIN)>=13 then
		Duel.BreakEffect()
		Duel.SetLP(1-tp,Duel.GetLP())
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)-Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		if ct>0 and Duel.IsPlayerCanDiscardDeck(1-tp,ct) then
			Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
		end
	end
end
