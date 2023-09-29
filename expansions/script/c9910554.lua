--甜心机仆 泪光的礼物
Duel.LoadScript("c9910550.lua")
function c9910554.initial_effect(c)
	--special summon
	QutryTxjp.AddSpProcedure(c,9910554)
	--flag
	QutryTxjp.AddTgFlag(c)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x11e0)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c9910554.rmcost)
	e2:SetTarget(c9910554.rmtg)
	e2:SetOperation(c9910554.rmop)
	c:RegisterEffect(e2)
end
function c9910554.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable()
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c9910554.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c9910554.rmfilter(c)
	return c:IsSetCard(0x3951) and c:IsAbleToRemove() and not c:IsCode(9910554)
end
function c9910554.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 or Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==0 then return end
	local g1=Duel.GetMatchingGroup(c9910554.rmfilter,tp,LOCATION_GRAVE,0,nil)
	if #g1>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(tp,aux.Stringid(9910554,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		if Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)==0 then return end
		local sg2=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
		Duel.SendtoGrave(sg2,REASON_DISCARD+REASON_EFFECT)
	end
end
