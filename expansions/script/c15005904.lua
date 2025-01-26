local m=15005904
local cm=_G["c"..m]
cm.name="狂音主的前路"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.disfilter(c)
	return c:IsDisabled() and c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAbleToHand()
end
function cm.tdfilter(c)
	return c:IsSetCard(0x6f43) and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND)
		local g=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	else
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local g=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,5,nil)
		if g:GetCount()>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end