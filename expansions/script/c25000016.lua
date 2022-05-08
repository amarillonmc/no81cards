local m=25000016
local cm=_G["c"..m]
cm.name="局外人"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.etg)
	e2:SetOperation(cm.eop)
	c:RegisterEffect(e2)
end
function cm.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g,rc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS),re:GetHandler()
		return ev and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and #g==1 and g:GetFirst()~=rc and re:IsActivated() and Duel.CheckChainTarget(ev,rc)
	end
end
function cm.eop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,m)
	Duel.ChangeTargetCard(ev,Group.FromCards(re:GetHandler()))
end
