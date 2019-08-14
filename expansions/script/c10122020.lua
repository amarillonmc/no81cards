--乌托兰最深层-迷失域的主人
function c10122020.initial_effect(c)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(10122011)
	c:RegisterEffect(e1)   
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10122020,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCondition(c10122020.condition)
	e2:SetCost(c10122020.cost)
	e2:SetTarget(c10122020.target)
	e2:SetOperation(c10122020.operation)
	e2:SetLabel(LOCATION_DECK)
	c:RegisterEffect(e2)
	--activate2
	local e3=e2:Clone()
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.TRUE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c10122020.target)
	e3:SetOperation(c10122020.operation)
	e3:SetLabel(LOCATION_HAND)
	c:RegisterEffect(e3) 
end
function c10122020.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c10122020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10122020.filter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true) and c:IsSetCard(0xc333)
end
function c10122020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10122020.filter,tp,e:GetLabel(),0,1,nil,tp) end
end
function c10122020.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10122020,0))
	local tc=Duel.SelectMatchingCard(tp,c10122020.filter,tp,e:GetLabel(),0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
