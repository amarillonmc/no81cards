local m=53796050
local cm=_G["c"..m]
cm.name="金下落"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c,tid)
	local re=c:GetReasonEffect()
	return c:GetTurnID()==tid and (c:IsReason(REASON_EFFECT) or (re and re:IsActivated())) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc,tid) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,2,nil,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,2,2,nil,tid)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,PLAYER_ALL,LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local oc=g:Select(1-tp,1,1,nil):GetFirst()
	oc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
	if Duel.SendtoHand(oc,1-tp,REASON_EFFECT)~=0 and oc:IsLocation(LOCATION_HAND) then
		local sc=Group.__sub(g,oc):GetFirst()
		if not sc then return end
		sc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(sc,tp,REASON_EFFECT)
	end
end
