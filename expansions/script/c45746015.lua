--H×H 酷拉皮卡
function c45746015.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PSYCHO),2,2)


	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45746015,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,45746015)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c45746015.cost)
	e2:SetTarget(c45746015.chtg)
	e2:SetOperation(c45746015.chop)
	c:RegisterEffect(e2)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c45746015.lvcg)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(45746015,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c45746015.effcon)
	e3:SetOperation(c45746015.effop)
	c:RegisterEffect(e3)

end
--e2
function c45746015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c45746015.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x5880) and c:IsDestructable()
end
function c45746015.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45746015.filter1,rp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c45746015.chop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c45746015.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--e2
function c45746015.lvcg(e,c,rc)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x880) then
		return 4*65536+lv
	end
end
--e3
function c45746015.effcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_XYZ)~=0 and e:GetHandler():GetReasonCard():IsSetCard(0x880)
end
function c45746015.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(45746015,2))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c45746015.descost)
	e1:SetTarget(c45746015.destg)
	e1:SetOperation(c45746015.desop)
	c:RegisterEffect(e1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(45746015,2))
end
function c45746015.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c45746015.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c45746015.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(45746015,3))

		local tc=g:Select(tp,1,1,nil)
		local sg=tc:GetFirst()
		Duel.HintSelection(tc)
		if ((sg:IsFaceup() and not sg:IsDisabled()) or sg:IsType(TYPE_TRAPMONSTER))  then
			Duel.NegateRelatedChain(sg,RESET_TURN_SET)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sg:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e5:SetCode(EFFECT_DISABLE_EFFECT)
			e5:SetValue(RESET_TURN_SET)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sg:RegisterEffect(e5)
			if sg:IsType(TYPE_TRAPMONSTER) then
				local e6=Effect.CreateEffect(c)
				e6:SetType(EFFECT_TYPE_SINGLE)
				e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sg:RegisterEffect(e6)
			end
		end
	end
end