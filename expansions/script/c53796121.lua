local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,80513550)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.tdcon)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,80513550))
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetTarget(aux.TRUE)
	e5:SetValue(s.atlimit)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
function s.chainfilter(re,tp,cid)
	return not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL))
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_DRAW
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #g==0 then return end
	Duel.Hint(HINT_CARD,0,id)
	for i=0,1 do
		if g:IsExists(Card.IsControler,1,nil,i) then
			Duel.ConfirmCards(1-i,g)
			if not g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then Duel.ShuffleHand(i) end
		end
	end
	local sg=g:Filter(Card.IsType,nil,TYPE_SPELL)
	if #sg==0 then return end
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local c=e:GetHandler()
	for i=0,1 do
		if og:IsExists(Card.IsPreviousControler,1,nil,math.abs(i-tp)) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetRange(LOCATION_SZONE)
			e1:SetCondition(s.con(math.abs(i-tp)))
			e1:SetOperation(s.op)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1,true)
			c:RegisterFlagEffect(i,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,i))
		end
	end
end
function s.con(p)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local g=Duel.GetFieldGroup(1-p,LOCATION_MZONE,0)
				local tc=g:GetFirst()
				return #g==1 and tc:IsFaceup() and tc:IsLevelBelow(4) and re:IsActiveType(TYPE_SPELL) and rp==p
			end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function s.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetOwnerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function s.atlimit(e,c)
	return c:IsFaceup() and c:IsCode(80513550)
end