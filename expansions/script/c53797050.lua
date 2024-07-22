local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.econ)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e3:SetValue(s.atklimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetValue(id)
	e4:SetCondition(s.actcon)
	e4:SetCost(s.cost)
	c:RegisterEffect(e4)
end
function s.econ(e)
	return Duel.GetCurrentPhase()~=PHASE_MAIN2
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.atklimit(e,c)
	return c==e:GetHandler()
end
function s.actcon(e)
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_BE_BATTLE_TARGET,true)
	if res then
		return teg:GetFirst()==e:GetHandler()
	else return false end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetLabel(Duel.GetCurrentChain())
	e1:SetCondition(s.chaincon)
	e1:SetOperation(s.chainop)
	e1:SetReset(RESET_EVENT+0x17a0000+RESET_CHAIN)
	e:GetHandler():RegisterEffect(e1,true)
end
function s.chaincon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()~=e:GetLabel() or Duel.IsChainSolving() then return false end
	local te=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_EFFECT)
	return e:GetHandler():IsReason(REASON_COST) and te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:GetCode()==EVENT_ATTACK_ANNOUNCE
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetCurrentChain())
	e1:SetCondition(s.thcon)
	e1:SetOperation(s.thop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	e:GetHandler():CreateEffectRelation(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetLabel(Duel.GetCurrentChain())
	e2:SetCondition(s.chaincon2)
	e2:SetOperation(s.chainop2)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
	e1:SetLabelObject(e2)
end
function s.chaincon2(e,tp,eg,ep,ev,re,r,rp)
	if ev~=e:GetLabel() then return false end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetCode()==EVENT_ATTACK_ANNOUNCE
end
function s.chainop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(s.chainlm)
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return ev==e:GetLabel() and rc:IsRelateToEffect(re) and Duel.IsPlayerCanSendtoHand(tp,rc) and rc:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	rc:CancelToGrave()
	local c=e:GetOwner()
	if Duel.SendtoHand(rc,nil,REASON_EFFECT)~=0 and rc:IsLocation(LOCATION_HAND) and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
