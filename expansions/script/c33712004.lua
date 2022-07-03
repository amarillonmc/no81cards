local m=33712004
local cm=_G["c"..m]
cm.name="卑命抗争"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and Duel.GetFieldGroup(tp,LOCATION_DECK,0):FilterCount(Card.IsAbleToHand,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(Card.IsAbleToHand,nil)
	local max=7
	if #g<max then max=#g end   
	local t={}
	local i=1
	for i=1,max do t[i]=i end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
	local num=Duel.AnnounceNumber(tp,table.unpack(t))
	local sg=g:Select(1-tp,num,num,nil)
	if sg and #sg>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)+num*1000)
	end
end