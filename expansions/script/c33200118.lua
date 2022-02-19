--幻梦灵兽 精神击破
function c33200118.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--activate cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCost(c33200118.costchk)
	e1:SetOperation(c33200118.costop)
	c:RegisterEffect(e1)	
	--accumulate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(0x10000000+33200118)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,33200118)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c33200118.condition)
	e3:SetTarget(c33200118.target)
	e3:SetOperation(c33200118.activate)
	c:RegisterEffect(e3)
end

--e1
function c33200118.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,33200118)
	return Duel.CheckLPCost(tp,ct*500)
end
function c33200118.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end

--e3
function c33200118.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	e:SetLabelObject(d)
	return a:IsControler(1-tp) and d and d:IsControler(tp) and d:IsSetCard(0x324)
end
function c33200118.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,33200118)==0 end
end
function c33200118.activate(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	if at:IsFaceup() and at:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		at:RegisterEffect(e1)
	end
end
