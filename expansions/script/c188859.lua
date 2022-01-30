local m=188859
local cm=_G["c"..m]
cm.name="重起之凌寒-霜星"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1,1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(function(e)return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)end)
	e1:SetValue(function(e,te)return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,0x11e0)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.ztg)
	e2:SetOperation(cm.zop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetTarget(cm.damtg)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
end
function cm.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local zone=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	e:SetLabel(zone)
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,1-tp,zone>>16)
end
function cm.zop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetLabel()
	if tp==1 then zone=((zone&0xffff)<<16)|((zone>>16)&0xffff) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(zone)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e:GetHandler():RegisterEffect(e1)
	if zone&0x20002000~=0 then return end
	local filter=0
	local seq=math.floor(math.log(zone,2))
	if zone>8192 then seq=math.floor(math.log(zone>>16,2)) end
	if zone&0x1f001f00~=0 then
		local so=0
		if zone>8192 then so=16 end
		filter=filter|1<<(seq-8+so)
		if seq~=8 then filter=filter|1<<(seq-1+so) end
		if seq~=12 then filter=filter|1<<(seq+1+so) end
	end
	if zone&0x1f001f~=0 then
		local so,os=0,16
		if zone>8192 then so,os=16,0 end
		filter=filter|1<<(seq+8+so)
		if seq~=0 then filter=filter|1<<(seq-1+so) end
		if seq~=4 then filter=filter|1<<(seq+1+so) end
		if seq==1 then if zone>8192 then filter=filter|0x200040 else filter=filter|0x400020 end end
		if seq==3 then if zone>8192 then filter=filter|0x400020 else filter=filter|0x200040 end end
		if seq~=1 and seq~=3 then filter=filter|1<<(seq+os) end
	end
	if seq==5 then filter=filter|0x400020|1<<3|1<<17 end
	if seq==6 then filter=filter|0x200040|1<<1|1<<19 end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetLabel(filter)
	e2:SetCondition(cm.negcon)
	e2:SetOperation(cm.negop)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local loc=re:GetHandler():GetLocation()
	if loc&LOCATION_ONFIELD==0 or loc&LOCATION_FZONE~=0 then return false end
	local seq=re:GetHandler():GetSequence()
	local p=re:GetHandler():GetControler()
	local so=0
	if p~=tp then so=16 end
	if loc==LOCATION_MZONE then
		 if seq<5 then zone=1<<(seq+so) end
		 if seq==5 then if so==0 then zone=0x400020 else zone=0x200040 end end
		 if seq==6 then if so==0 then zone=0x200040 else zone=0x400020 end end
	end
	if loc==LOCATION_SZONE then
		if seq==6 then seq=0 end
		if seq==7 then seq=4 end
		zone=1<<(seq+8+so)
	end
	return Duel.IsChainDisablable(ev) and e:GetLabel()&zone~=0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateEffect(ev)
	e:Reset()
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetHandler():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,e:GetHandler():GetAttack())
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
