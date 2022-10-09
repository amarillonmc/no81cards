local m=53796071
local cm=_G["c"..m]
cm.name="上发条的独角仙"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.acop)
	c:RegisterEffect(e2)
	if not cm.Kabutomushi_check then
		cm.Kabutomushi_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	if ct==0 then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		if tc:GetFlagEffect(m)==0 then tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0,0) end
		local nct=tc:GetFlagEffectLabel(m)
		tc:SetFlagEffectLabel(m,nct+ct)
	end
	Duel.AdjustAll()
end
function cm.filter(c)
	return c:GetFlagEffect(m)>0 and c:GetFlagEffectLabel(m)>3
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
