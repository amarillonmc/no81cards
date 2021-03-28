--人理之诗 双腕·零次束集
function c22020450.initial_effect(c)
	aux.AddCodeList(c,22020430)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22020450+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22020450.con)
	e1:SetTarget(c22020450.target)
	e1:SetOperation(c22020450.activate)
	c:RegisterEffect(e1)
end
function c22020450.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x2ff1)
end
function c22020450.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22020450.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c22020450.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22020450.dfilter(c)
	return c:IsFaceup() and c:IsCode(22020430)
end
function c22020450.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c22020450.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local dg=Duel.GetMatchingGroup(c22020450.desfilter,tp,0,LOCATION_ONFIELD,nil)
	local dg1=Duel.GetMatchingGroup(c22020450.dfilter,tp,LOCATION_ONFIELD,0,nil)
	if dg:GetCount()>0 and dg1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22020450,0)) then
		Duel.BreakEffect()
		local ct=Duel.Destroy(dg,REASON_EFFECT)
	end
	Debug.Message("在此宣告——天之杯启动，将万物引向终焉")
	Debug.Message("双腕！零次束集！")
end
