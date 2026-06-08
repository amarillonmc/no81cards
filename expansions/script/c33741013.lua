--Echoes Kernel #Mζ - Clear Poo
local s,id,o=GetID()
Duel.LoadScript("c33741000.lua")
function s.initial_effect(c)
	DEchoes.AddKernelFusion(c,RACE_AQUA)
	DEchoes.AddGrantTrigger(c,id,s.grant)
end
function s.cfilter(c)
	return DEchoes.IsEchoes(c) and c:IsType(TYPE_MONSTER)
end
function s.tgfilter(c)
	return c:IsFaceup() and c:IsControler(1-Duel.GetTurnPlayer())
end
function s.grant(e,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.mfilter(c)
	return c:IsFaceup()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.mfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.mfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.mfilter,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabel(eg:Filter(s.cfilter,nil):GetFirst():GetPreviousAttackOnField(),eg:Filter(s.cfilter,nil):GetFirst():GetPreviousDefenseOnField())
end
function s.stfilter(c,seq)
	return c:IsFaceup() and c:IsSequence(seq) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	local atk,def=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(-def)
	tc:RegisterEffect(e2)
	if tc:GetAttack()==0 and tc:IsCanBeDisabledByEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_DISABLE)
		e3:SetValue(0)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e4)
	end
	if tc:GetDefense()==0 then
		local seq=tc:GetSequence()
		local g=Duel.GetMatchingGroup(s.stfilter,tp,0,LOCATION_SZONE,nil,seq)
		for sc in aux.Next(g) do
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_DISABLE)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e5)
		end
	end
end
