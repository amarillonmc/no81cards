--漏油
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil) then
			Duel.SetChainLimit(aux.FALSE)
		else
			Duel.SetChainLimit(s.chainlm)
		end
	end
end
function s.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCost(s.costchk)
	e1:SetTarget(s.actarget)
	e1:SetOperation(s.costop)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(1-tp,id,RESET_PHASE+PHASE_END,0,1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(s.disop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.costchk(e,te,tp)
	local ct=Duel.GetFlagEffect(tp,id)
	e:SetLabelObject(te)
	return ct==0 or Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2*ct,te:GetHandler())
end
function s.actarget(e,te,tp)
	return te:GetHandler():IsOnField() or te:GetHandler():IsLocation(LOCATION_GRAVE) and te:GetHandler():IsType(TYPE_MONSTER)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD,te:GetHandler())
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)<=1 then
		local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
		for tc in aux.Next(g) do
			  local e1=Effect.CreateEffect(e:GetHandler())
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetCode(EFFECT_DISABLE)
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			  tc:RegisterEffect(e1)
			  local e2=Effect.CreateEffect(e:GetHandler())
			  e2:SetType(EFFECT_TYPE_SINGLE)
			  e2:SetCode(EFFECT_DISABLE_EFFECT)
			  e2:SetValue(RESET_TURN_SET)
			  e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			  tc:RegisterEffect(e2)
			  local e3=Effect.CreateEffect(e:GetHandler())
			  e3:SetType(EFFECT_TYPE_SINGLE)
			  e3:SetCode(EFFECT_SET_ATTACK)
			  e3:SetValue(0)
			  e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			  tc:RegisterEffect(e3)
			  local e4=Effect.CreateEffect(e:GetHandler())
			  e4:SetType(EFFECT_TYPE_SINGLE)
			  e4:SetCode(EFFECT_SET_DEFENSE)
			  e4:SetValue(0)
			  e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			  tc:RegisterEffect(e4)
		end
	end
end
