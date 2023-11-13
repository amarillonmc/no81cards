--永夏的梦萦
function c9910975.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9910975)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9910975.cost)
	e1:SetTarget(c9910975.target)
	e1:SetOperation(c9910975.activate)
	c:RegisterEffect(e1)
	--set monster
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910985)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910975.settg)
	e2:SetOperation(c9910975.setop)
	c:RegisterEffect(e2)
end
function c9910975.costfilter(c)
	return c:IsSetCard(0x5954) and c:IsDiscardable()
end
function c9910975.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910975.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c9910975.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c9910975.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910975.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c9910975.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910975.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9910975.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9910975.disfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsCanBeDisabledByEffect(e)
end
function c9910975.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(c9910975.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(9910975,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			sc:RegisterEffect(e2)
			--
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e3:SetTarget(c9910975.distg)
			e3:SetLabelObject(sc)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_CHAIN_SOLVING)
			e4:SetCondition(c9910975.discon)
			e4:SetOperation(c9910975.disop)
			e4:SetLabelObject(sc)
			e4:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e4,tp)
		end
	end
end
function c9910975.distg(e,c)
	local sc=e:GetLabelObject()
	return c:IsOriginalCodeRule(sc:GetOriginalCodeRule())
end
function c9910975.discon(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(sc:GetOriginalCodeRule())
end
function c9910975.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c9910975.csfilter(c,e,tp)
	if c:IsType(TYPE_TOKEN) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e1,true)
	local res=c:IsSSetable(true)
	e1:Reset()
	return res and c:IsSummonType(SUMMON_TYPE_SPECIAL) and not c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c9910975.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9910975.csfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910975.csfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	Duel.SelectTarget(tp,c9910975.csfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
end
function c9910975.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		Duel.ConfirmCards(1-tp,tc)
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
