--人理之诗 告死天使
function c22021990.initial_effect(c)
	aux.AddCodeList(c,22021960)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22021990+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22021990.cost)
	e1:SetTarget(c22021990.target)
	e1:SetOperation(c22021990.activate)
	c:RegisterEffect(e1)
end
function c22021990.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(REASON_COST,tp,aux.TRUE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	Duel.SelectOption(tp,aux.Stringid(22021990,0))
	Duel.SelectOption(tp,aux.Stringid(22021990,1))
	local g=Duel.SelectReleaseGroup(REASON_COST,tp,aux.TRUE,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c22021990.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c22021990.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_RULE)>0 then
		if Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,22021970)>=1 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetTarget(c22021990.sumlimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			Duel.RegisterEffect(e2,tp)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_MSET)
			Duel.RegisterEffect(e3,tp)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_CANNOT_ACTIVATE)
			e4:SetValue(c22021990.aclimit)
			Duel.RegisterEffect(e4,tp)
		end
	end
	Duel.SelectOption(tp,aux.Stringid(22021990,2))
end
function c22021990.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function c22021990.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end