local m=15006125
local cm=_G["c"..m]
cm.name="行吟的塞莱丝塔"
function cm.initial_effect(c)
	aux.AddCodeList(c,15006126)
	--
	c:EnableReviveLimit()
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--draw count
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.xcon)
	e2:SetValue(2)
	c:RegisterEffect(e2)
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetCondition(cm.xcon)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetCondition(cm.xcon)
	e4:SetTarget(aux.TRUE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(cm.xcon)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e5:SetValue(aux.TargetBoolFunction(Card.GetBaseDefense))
	c:RegisterEffect(e5)
	--
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return ep==tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and ((not re) or ((not re:GetHandler():IsCode(15006125)) and re~=e))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local val=Duel.Recover(tp,math.ceil(ev/2),REASON_EFFECT)
	if val>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(ep,m,0,0,1,ev)
	local val=0
	if Duel.GetFlagEffect(ep,m)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(ep,m)} do
			val=val+i
		end
	end
	if val>=8000 and not Duel.IsPlayerAffectedByEffect(ep,15006126) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(15006126)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,ep)
	end
end
function cm.xcon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.IsPlayerAffectedByEffect(tp,15006126)
end