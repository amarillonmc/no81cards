--乌鸦皆黑？
local m=14010043
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.toss_coin=true
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.filter(c)
	return (c:IsOnField() and c:IsFacedown()) or (c:IsLocation(LOCATION_HAND) and not c:IsPublic())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tc=Duel.GetFirstTarget()
	local res=Duel.TossCoin(tp,1)
	if res==1 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
		Duel.ConfirmCards(tp,g)
		local tg=g:Filter(function(c) return c:IsCode(ac,tc:GetCode()) end,tc)
		if tg:GetCount()>0 then
			if tc:IsRelateToEffect(e) then
				tg:AddCard(tc)
			end
			Duel.Destroy(tg,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	else
		if tc:IsRelateToEffect(e) then
			Duel.ConfirmCards(tp,tc)
			if not tc:IsCode(ac) then
				Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
			end
		end
	end
end