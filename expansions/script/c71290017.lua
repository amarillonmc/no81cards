--半融冰晶 伊薇特
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	MTC.StrinovaPUS(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e0:SetCondition(cm.con)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.sumlimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e2)
	--activate limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(cm.con2)
	e4:SetValue(cm.alimit)
	c:RegisterEffect(e4)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e4:SetCondition(cm.con3)
	e4:SetTarget(cm.rmlimit)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
	--summon,flip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(cm.con4)
	e1:SetOperation(cm.handes)
	c:RegisterEffect(e1)
	
	MTC.StrinovaChangeZone(c,cm.czop)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)==0 and c:GetFlagEffect(m+10000000)==0 and c:GetFlagEffect(m+20000000)==0 and c:GetFlagEffect(m+30000000)==0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=aux.SelectFromOptions(tp,{true,aux.Stringid(m,1)},{true,aux.Stringid(m,2)},{true,aux.Stringid(m,3)},{true,aux.Stringid(m,4)})
	if op~=0 then c:RegisterFlagEffect(m+op*10000000,RESET_EVENT+RESETS_REDIRECT,0,1) end
end
function cm.con1(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)+Duel.GetFlagEffect(tp,m)>0
end
function cm.con2(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(m+10000000)+Duel.GetFlagEffect(tp,m+10000000)>0
end
function cm.con3(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(m+20000000)+Duel.GetFlagEffect(tp,m+20000000)>0
end
function cm.con4(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(m+30000000)+Duel.GetFlagEffect(tp,m+30000000)>0
end
function cm.sumlimit(e,c,tp,sumtp)
	return bit.band(sumtp,SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function cm.alimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.rmlimit(e,c)
	return c:GetOriginalType()&(TYPE_SPELL+TYPE_TRAP)~=0 and c:GetOwner()~=e:GetHandlerPlayer()
end

cm[0]=0
function cm.handes(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID)
	if ep==tp or loc~=LOCATION_MZONE or id==cm[0] or not re:IsActiveType(TYPE_MONSTER) then return end
	cm[0]=id
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		Duel.BreakEffect()
		if c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		else
			Duel.SendtoGrave(c,REASON_RULE)
		end
	else Duel.NegateEffect(ev) end
end

function cm.czop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local b1,b2,b3,b4=false
	if Duel.GetFlagEffect(tp,m)==0 then b1=true end
	if Duel.GetFlagEffect(tp,m+10000000)==0 then b2=true end
	if Duel.GetFlagEffect(tp,m+20000000)==0 then b3=true end
	if Duel.GetFlagEffect(tp,m+30000000)==0 then b4=true end
	local op=aux.SelectFromOptions(tp,
		{true,aux.Stringid(m,1)},
		{true,aux.Stringid(m,2)},
		{true,aux.Stringid(m,3)},
		{true,aux.Stringid(m,4)})
	if op~=0 then Duel.RegisterFlagEffect(tp,m+op*10000000,RESET_PHASE+PHASE_END,0,1) end
end

