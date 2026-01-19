--棕岩之承继 薇瑟妮娅
-- c12345679.lua
local s,id,o=GetID()
function s.initial_effect(c)
	-- Pendulum Set
	aux.EnablePendulumAttribute(c)
	-- P Effect: Scale Change & Place/ToExtra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.ptg)
	e1:SetOperation(s.pop)
	c:RegisterEffect(e1)
	-- Monster Effect: Buff ATK/DEF & Pierce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end

-- Pendulum Effect (Same as Card 1)
function s.pfilter(c)
	return c:IsSetCard(0x6c74) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,0,tp,LOCATION_DECK)
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	
	local scl=c:GetLeftScale()
	local b1=scl<13
	local b2=scl>0
	
	if not b1 and not b2 then return end
	
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)})
	
	local val=(op==1) and 1 or -1
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
	
	local g=Duel.GetMatchingGroup(s.pfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if not tc then return end
		
		local b_zone=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		local b_extra=true
		
		local op2=aux.SelectFromOptions(tp,
			{b_zone,aux.Stringid(id,5)},
			{b_extra,aux.Stringid(id,6)})
			
		if op2==1 then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SendtoExtraP(tc,tp,REASON_EFFECT)
		end
	end
end

-- Monster Effect
function s.bufffilter(c)
	return c:IsLevel(9) or c:IsRank(9)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.bufffilter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- ATK/DEF Boost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.atktarget)
	e1:SetValue(900)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
	
	-- Pierce (Conditional)
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if ag:GetClassCount(Card.GetAttribute)>=3 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_PIERCE)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(s.atktarget)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.atktarget(e,c)
	return c:IsLevel(9) or c:IsRank(9)
end
