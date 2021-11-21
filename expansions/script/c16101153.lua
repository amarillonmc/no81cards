--一点也不痛苦的选择
local m=16101153
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.thfilter(c)
	return true
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if chk==0 then return ct>=5 end
end
function cm.thop(e,tp)
	local rg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if rg:GetClassCount(Card.GetCode)<5 then return end
	local g=Group.CreateGroup()
	Duel.BreakEffect()
	for i=1,5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tc=rg:Select(tp,1,1,nil):GetFirst()
		if tc then
			g:AddCard(tc)
			rg:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	if g:GetCount()>=5 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ConfirmCards(1-tp,g)
	end
end