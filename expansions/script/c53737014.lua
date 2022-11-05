local m=53737014
local cm=_G["c"..m]
cm.name="异赤次元合成体 驭兽"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6e),5,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cm.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,1)
	e5:SetValue(cm.aclimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(cm.reptg)
	e6:SetValue(cm.repval)
	e6:SetOperation(cm.repop)
	c:RegisterEffect(e6)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e6:SetLabelObject(g)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function cm.value(e,c)
	return Duel.GetMatchingGroupCount(cm.filter,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)*1000
end
function cm.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_REMOVED
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and not c:IsReason(REASON_REPLACE) and c:GetFlagEffect(m)==0
end
function cm.desfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(cm.repfilter,nil,tp)
	local rg=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if chk==0 then return ct>0 and #rg>0 end
	Duel.Hint(HINT_CARD,0,m)
	if eg:Filter(cm.repfilter,nil,tp):IsContains(e:GetHandler()) then e:SetLabel(1) else e:SetLabel(0) end
	if ct>#rg then ct=#rg end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
	local tg=rg:Select(tp,ct,ct,nil)
	local g=e:GetLabelObject()
	g:Clear()
	local tc=tg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
		g:AddCard(tc)
		tc=tg:GetNext()
	end
	return true
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT+REASON_REPLACE)
	if e:GetLabel()==0 then return end
	local c=e:GetHandler()
	if c:GetFlagEffect(m+50)~=0 then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(m+50,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetCondition(cm.descon)
	e1:SetOperation(cm.desop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(m+50)==e:GetLabel()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end
