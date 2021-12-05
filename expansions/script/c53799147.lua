local m=53799147
local cm=_G["c"..m]
cm.name="银语百连发大作战！"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,1,m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) GetMZoneCount
	local e4=e2:Clone()
	e4:SetCode(EVENT_MSET)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_SSET)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetCode(EVENT_CHANGE_POS)
	e6:SetCondition(cm.con)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetRange(LOCATION_SZONE)
	e7:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e7:SetCode(EVENT_CUSTOM+m)
	e7:SetOperation(cm.operation)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_CUSTOM+(m+333))
	e8:SetOperation(cm.operation2)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EVENT_CUSTOM+(m+666))
	e9:SetOperation(cm.operation3)
	c:RegisterEffect(e9)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	for tc in aux.Next(eg) do
		if tc:IsControler(0) then g1:AddCard(tc) else g2:AddCard(tc) end
	end
	if g2:GetCount()>0 then Duel.RaiseEvent(g1,EVENT_CUSTOM+m,re,r,rp,0,0) end
	if g1:GetCount()>0 then Duel.RaiseEvent(g2,EVENT_CUSTOM+m,re,r,rp,1,0) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local c=e:GetHandler()
	local d=500
	if c:IsControler(tp) then d=0 end
	c:RegisterFlagEffect(m+d,RESET_EVENT+RESETS_STANDARD,0,0)
	local label=c:GetFlagEffectLabel(m+d+250)
	if label==nil then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp)
		c:RegisterFlagEffect(m+d+250,RESET_EVENT+RESETS_STANDARD,0,0,ac)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=0
		if c:GetFlagEffect(m+d+250)<10 then ac=Duel.AnnounceCard(tp) else ac=Duel.AnnounceCard(tp,label,OPCODE_ISCODE,OPCODE_NOT) end
		if ac==label then
			c:RegisterFlagEffect(m+d+250,RESET_EVENT+RESETS_STANDARD,0,0,ac)
			local cg=Duel.GetFieldGroup(tp,0,0xe)
			if c:GetFlagEffect(m+d+250)==10 and #cg>0 then Duel.RaiseEvent(cg,EVENT_CUSTOM+(m+333),re,r,rp,d/500,ac) end
		else
			if c:GetFlagEffect(m+d+250)<10 then Duel.SetLP(tp,Duel.GetLP(tp)-800) end
			c:ResetFlagEffect(m+d+250)
			c:RegisterFlagEffect(m+d+250,RESET_EVENT+RESETS_STANDARD,0,0,ac)
		end
	end
	local dg=Duel.GetFieldGroup(tp,0xe,0xe)
	if c:GetFlagEffect(m+d)==100 and #dg>0 then Duel.RaiseEvent(dg,EVENT_CUSTOM+(m+666),re,r,rp,d/500,0) end
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(tp,eg)
	local g=eg:Filter(Card.IsCode,nil,ev)
	if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_EFFECT) else Duel.SetLP(tp,Duel.GetLP(tp)-2000) end
	Duel.ShuffleHand(1-tp)
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(eg,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	if ct>0 then Duel.SetLP(1-tp,Duel.GetLP(1-tp)-ct*1000) end
end
