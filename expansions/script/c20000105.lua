--暴轮的裁决
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000101") end) then require("script/c20000101") end
function cm.initial_effect(c)
	local e1={fu_judg.E(c)}
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and ((a:IsControler(tp) and a:IsSummonType(SUMMON_TYPE_ADVANCE) and a:IsRelateToBattle())
		or (d:IsControler(tp) and d:IsSummonType(SUMMON_TYPE_ADVANCE) and d:IsRelateToBattle()))
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	a=a:IsControler(tp) and d or a
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetOperation(cm.op2op)
	a:RegisterEffect(e1)
end
function cm.op2op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToBattle() then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end