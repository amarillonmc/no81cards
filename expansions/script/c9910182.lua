--匪魔的骚乱
function c9910182.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9910182)
	e1:SetCondition(c9910182.condition)
	e1:SetCost(c9910182.cost)
	e1:SetTarget(c9910182.target)
	e1:SetOperation(c9910182.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910183)
	e2:SetOperation(c9910182.regop)
	c:RegisterEffect(e2)
end
function c9910182.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and (LOCATION_HAND+LOCATION_GRAVE)&loc~=0
end
function c9910182.cfilter(c)
	return c:IsSetCard(0x3954) and c:IsFacedown()
end
function c9910182.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910182.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c9910182.cfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
end
function c9910182.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local p=rc:GetControler()
	if chk==0 then return rc:IsRelateToEffect(re) and Duel.GetLocationCount(p,LOCATION_MZONE,tp)>0
		and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,p) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,rc,1,0,0)
end
function c9910182.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) then return end
	if aux.NecroValleyNegateCheck(rc) then return end
	if Duel.SpecialSummon(rc,0,tp,rc:GetControler(),false,false,POS_FACEDOWN_DEFENSE)==0 then return end
	Duel.ConfirmCards(1-tp,rc)
	if c:IsRelateToEffect(e) then
		c:CancelToGrave()
		local b1=c:IsFaceup() and c:IsSSetable(true)
		local b2=c:IsAbleToDeck()
		if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(9910182,0),aux.Stringid(9910182,1))==0) then
			Duel.BreakEffect()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		elseif b2 then
			Duel.BreakEffect()
			Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetCondition(c9910182.negcon)
			e1:SetOperation(c9910182.negop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		else
			c:CancelToGrave(false)
		end
	end
end
function c9910182.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and Duel.GetFlagEffect(tp,9910182)<1
end
function c9910182.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(9910182,2)) then return end
	Duel.Hint(HINT_CARD,0,9910182)
	Duel.RegisterFlagEffect(tp,9910182,RESET_PHASE+PHASE_END,0,1)
	Duel.NegateEffect(ev)
end
function c9910182.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910182.spcon)
	e1:SetOperation(c9910182.spop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910182.spfilter(c,e,tp)
	if not (c:IsSetCard(0x3954) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c9910182.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910182.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c9910182.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910182)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910182.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
