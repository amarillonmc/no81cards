--抽象天皇
function c9980716.initial_effect(c)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980716,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,9980716)
	e3:SetCost(c9980716.necost)
	e3:SetTarget(c9980716.netg)
	e3:SetOperation(c9980716.neop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980716.sumsuc)
	c:RegisterEffect(e8)
end
function c9980716.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980716,0))
end 
function c9980716.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9980716.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsDisabled()
end
function c9980716.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9980716.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return
		Duel.IsExistingMatchingCard(c9980716.filter1,tp,0,LOCATION_ONFIELD,1,nil)
	end
end
function c9980716.neop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9980716.filter2,tp,0,LOCATION_ONFIELD,1,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980716,0))
end