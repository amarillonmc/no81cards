--闇邪咏奏-王权傀儡
local s,id,o=GetID()
function s.initial_effect(c)
	s.imm(c)
	s.set(c)
end
function s.imm(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1125)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+1)
	e1:SetCost(s.immcost)
	e1:SetTarget(s.immtg)
	e1:SetOperation(s.immop)
	c:RegisterEffect(e1)
end
function s.immcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.immfilter(c)
	return c:IsAttackPos() and c:IsSetCard(0x897) and c:IsType(TYPE_MONSTER)
end
function s.immtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.immfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.immop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.immfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end

function s.set(c)
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,id+1)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(s.settg)
	e5:SetOperation(s.setop)
	c:RegisterEffect(e5)
end
function s.setfilter(c)
	return c:IsFaceupEx() and c:IsCode(71210110) and c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.SSet(tp,tc)
	end
end

