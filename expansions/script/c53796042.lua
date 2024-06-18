local m=53796042
local cm=_G["c"..m]
cm.name="我屋"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
cm[0]=0
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local s=Duel.SelectField(tp,1,LOCATION_MZONE,0,0x60)
	e:SetLabel(s,tp)
	Duel.Hint(HINT_ZONE,tp,s)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local z,p=e:GetLabel()
	if p==1 then z=((z&0xffff)<<16)|((z>>16)&0xffff) end
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	--e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetLabel(z)
	e2:SetTarget(cm.tg)
	e2:SetValue(cm.val)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetLabel(z)
	e3:SetOperation(cm.handes)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
end
function cm.tg(e,c)
	local o=c:GetControler()*16
	return 1<<(c:GetSequence()+o)==e:GetLabel()
end
function cm.val(e,re)
	return e:GetHandler()~=re:GetOwner() and re:GetOwner()~=e:GetOwner()
end
function cm.handes(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_CHAIN_ID)
	if ep~=tp or loc~=LOCATION_MZONE or id==cm[0] or not re:IsActiveType(TYPE_MONSTER) then return end
	local o=ep*16
	if 1<<(seq+o)==e:GetLabel() then return end
	cm[0]=id
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsChainDisablable(ev) and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		Duel.NegateEffect(ev)
	end
end
