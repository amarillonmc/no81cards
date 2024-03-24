--噩梦回廊的编织者 有栖
function c67200761.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200761,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,67200761)
	e1:SetCost(c67200761.stcost)
	e1:SetTarget(c67200761.sttg)
	e1:SetOperation(c67200761.stop)
	c:RegisterEffect(e1)	
end
function c67200761.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c67200761.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x367d) and c:IsSSetable()
end
function c67200761.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200761.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c67200761.checkfilter1(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsType(TYPE_TRAP)
end
function c67200761.checkfilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsType(TYPE_QUICKPLAY)
end
function c67200761.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c67200761.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		local og=Duel.GetOperatedGroup()
		if og:IsExists(c67200761.checkfilter1,1,nil,tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1)
		end
		if og:IsExists(c67200761.checkfilter2,1,nil,tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetTargetRange(0xff,0xff)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetTarget(c67200761.rmtarget)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c67200761.rmtarget(e,c)
	return c:GetOriginalType()&TYPE_TRAP~=0
end