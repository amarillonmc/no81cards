local m=15005634
local cm=_G["c"..m]
cm.name="枯绿机关-尼西亚箭阵"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cm.tgfilter(c,tp)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x5f42) and c:IsType(TYPE_LINK) and c:IsLinkAbove(2) and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.thfilter(chkc) end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_EXTRA+LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_EXTRA+LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	local lk=g:GetFirst():GetLink()
	local ct=math.floor(lk/2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local count=og:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		if count>0 then
			Duel.BreakEffect()
			Duel.SetLP(tp,Duel.GetLP(tp)-count*1000)
		end
	end
end