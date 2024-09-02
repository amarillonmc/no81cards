local m=15005624
local cm=_G["c"..m]
cm.name="枯绿术式-『卡慕卡拉风啸剑刃』"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TODECK+CATEGORY_TOEXTRA)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.atkfilter(c)
	return c:IsSetCard(0xf42) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:GetBaseAttack()>0 and c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return 
		Duel.IsExistingTarget(cm.atkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACK)
	local g1=Duel.SelectTarget(tp,cm.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tdc=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED):GetFirst()
	local atkc=tg:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst()
	if tdc then
		Duel.SendtoDeck(tdc,nil,2,REASON_EFFECT)
		local tdg=Duel.GetOperatedGroup()
		if tdg:GetCount()==0 then return end
		local sg=tdg:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_EXTRA)
		local atk=sg:GetSum(Card.GetBaseAttack)
		if atkc and atk>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(atk)
			atkc:RegisterEffect(e1)
		end
	end
end