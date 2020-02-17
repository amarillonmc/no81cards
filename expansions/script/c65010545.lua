local m=65010545
local tg={65010522,65010550}
local cm=_G["c"..m]
cm.name="白魔军魂 艾斯德斯"--白魔军魂 艾斯德斯
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.NonTuner(cm.tunfil),nil,nil,aux.Tuner(Card.IsRace,RACE_FAIRY),2,99)
	c:EnableReviveLimit()
	 --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.tg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function cm.tunfil(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FAIRY)
end
function cm.tg(e,c)
	return c:IsRace(RACE_FAIRY) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	--disable
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE+PHASE_END)
	e1:SetTarget(cm.disable)
	e1:SetCode(EFFECT_DISABLE)
	Duel.RegisterEffect(e1,tp)
	 --
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE+PHASE_END)
	e2:SetOperation(cm.operation)
	Duel.RegisterEffect(e2,tp)
	--atkchange
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetReset(RESET_PHASE+PHASE_BATTLE+PHASE_END)
	e3:SetTarget(cm.atktg)
	e3:SetValue(cm.atkval)
	Duel.RegisterEffect(e3,tp)
end
function cm.disable(e,c)
	return c:IsFaceup() and (c:GetSummonLocation()==LOCATION_DECK or c:GetSummonLocation()==LOCATION_EXTRA)
end
function cm.disablec(c)
	return c:IsFaceup() and (c:GetSummonLocation()==LOCATION_DECK or c:GetSummonLocation()==LOCATION_EXTRA)
end
function cm.gfil(c,g)
	return c:GetFlagEffect(m)==0
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g=Duel.GetMatchingGroup(cm.disablec,tp,0,LOCATION_MZONE,nil)
	if g:IsExists(cm.gfil,1,nil) then
		local g1=g:Filter(cm.gfil,nil)
		local g1c=g1:GetFirst()
		while g1c do
			g1c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
			g1c=g1:GetNext()
		end
		Duel.Readjust()
	end
end
function cm.atktg(e,c)
	return c:GetFlagEffect(m)>0
end
function cm.atkval(e,c)
	return math.ceil(c:GetAttack()/2)
end