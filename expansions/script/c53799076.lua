local m=53799076
local cm=_G["c"..m]
cm.name="NEL"
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,nil,3,99,cm.lcheck)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
cm[0]=0
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local id=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if ep==tp or id==cm[0] then return end
	cm[0]=id
	if Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
function cm.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
