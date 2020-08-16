--时间逆流
function c49966673.initial_effect(c)
	 local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49966673,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c49966673.rmcon)
	e3:SetTarget(c49966673.rmtg)
	e3:SetOperation(c49966673.rmop)
	c:RegisterEffect(e3)
	  if not c49966673.global_check then
		c49966673.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c49966673.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c49966673.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(49966673,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c49966673.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_END
end
function c49966673.filter(c,turn)
	return (c:IsLocation(LOCATION_MZONE) or c:GetFlagEffect(49966673)~=0) and c:GetTurnID()==turn and c:IsAbleToRemove()
end
function c49966673.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49966673.filter,tp,0,LOCATION_ONFIELD,1,nil,Duel.GetTurnCount()) end
	local g=Duel.GetMatchingGroup(c49966673.filter,tp,0,LOCATION_ONFIELD,nil,Duel.GetTurnCount())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c49966673.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c49966673.filter,tp,0,LOCATION_ONFIELD,nil,Duel.GetTurnCount())
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end