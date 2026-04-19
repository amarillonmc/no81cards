--弐世坏斗魂
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,56099748)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.reptg)
	e1:SetValue(s.repval)
	e1:SetOperation(s.repop)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsDefenseAbove(0) and (c:IsSetCard(0xc3b) or c:IsCode(56099748))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.efilter(c,e)
	return s.filter(c) and not c:IsImmuneToEffect(e)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.efilter,tp,LOCATION_MZONE,0,nil,e)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		local batk=tc:GetBaseAttack()
		local bdef=tc:GetBaseDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK_FINAL)
		e1:SetValue(bdef)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE_FINAL)
		e2:SetValue(batk)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
end
function s.dfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function s.repfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc3b) and c:IsAbleToGrave()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.dfilter,1,nil,tp) and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.dfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_CARD,0,id)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
end
