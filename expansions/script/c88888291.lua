--困兽游斗之沧泉枢
function c88888291.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,88888291)
	e1:SetTarget(c88888291.tg)
	e1:SetOperation(c88888291.op)
	c:RegisterEffect(e1)
end
function c88888291.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c88888291.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local ct=1
	if Duel.IsExistingMatchingCard(c88888291.cfilter,tp,LOCATION_MZONE,0,1,nil) then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c88888291.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==0 then return end
	local rg=Duel.GetMatchingGroup(c88888291.cfilter,tp,LOCATION_MZONE,0,nil):Filter(Card.IsReleasableByEffect,nil)
	if #rg~=0 and Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(88888291,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rrg=rg:Select(tp,1,1,nil)
		if Duel.Release(rrg,REASON_EFFECT)~=0 and Duel.Draw(tp,2,REASON_EFFECT)==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local dg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,REASON_EFFECT+REASON_DISCARD)
			if dg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.ShuffleHand(tp)
				Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD,tp)
			end
		end
	end
end
