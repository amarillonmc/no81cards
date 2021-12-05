--第 三 种 存 在
local m=53799040
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	e1:SetLabelObject(sg)
end
function cm.cfilter(c)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(cm.filter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c:GetOriginalCodeRule())
end
function cm.filter(c,code)
	return c:IsFaceup() and c:IsOriginalCodeRule(code)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,g:GetFirst():GetOriginalCodeRule()) end
	local sg=e:GetLabelObject()
	sg:Merge(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g==0 then return end
	local dg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local g2=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tc:GetOriginalCodeRule())
		if #g2>0 then dg:Merge(g2) end
		tc=g:GetNext()
	end
	Duel.SendtoHand(dg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,dg)
end
