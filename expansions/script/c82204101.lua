local m=82204101
local cm=_G["c"..m]
cm.name="黯影的羁绊"
--配 置
cm.discard=1	--丢 弃 数 量
cm.tograve=2	--堆 墓 数 量
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.disfilter(c)
	return c:IsDiscardable(REASON_EFFECT)
end
function cm.tgfilter(c)
	return c:IsSetCard(0x9d) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_HAND,0,cm.discard,nil)
		and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,cm.tograve,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,cm.discard)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,cm.tograve,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_HAND,0,cm.discard,nil)
		or Duel.DiscardHand(tp,cm.disfilter,cm.discard,cm.discard,REASON_EFFECT+REASON_DISCARD)<cm.discard then return end
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<cm.tograve then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,cm.tograve,cm.tograve,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end