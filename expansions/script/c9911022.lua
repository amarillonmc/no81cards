--沧海姬 法鲁斯
function c9911022.initial_effect(c)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911022)
	e1:SetCondition(c9911022.setcon1)
	e1:SetCost(c9911022.setcost)
	e1:SetTarget(c9911022.settg)
	e1:SetOperation(c9911022.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9911022.setcon2)
	c:RegisterEffect(e2)
	--change attribute
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9911023)
	e3:SetCondition(c9911022.attcon)
	e3:SetTarget(c9911022.atttg)
	e3:SetOperation(c9911022.attop)
	c:RegisterEffect(e3)
end
function c9911022.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9911005)
end
function c9911022.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9911005)
end
function c9911022.cfilter(c,tp,mc)
	local b1=c:IsLocation(LOCATION_HAND)
	local b2=c:IsLocation(LOCATION_EXTRA) and Duel.IsPlayerAffectedByEffect(tp,9911013)
		and Duel.GetFlagEffect(tp,9911013)==0 and mc:IsLevelAbove(0) and c:IsLevelAbove(mc:GetLevel()+1)
	return (b1 or b2) and c:IsReleasable()
end
function c9911022.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable()
		and Duel.IsExistingMatchingCard(c9911022.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,c,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c9911022.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,c,tp,c)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) then
		Duel.RegisterFlagEffect(tp,9911013,RESET_PHASE+PHASE_END,0,0)
	end
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_RELEASE+REASON_COST)
end
function c9911022.setfilter(c)
	return c:IsSetCard(0x6954) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c9911022.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911022.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c9911022.tgfilter(c)
	return c:IsRace(RACE_AQUA) and c:IsAbleToGrave()
end
function c9911022.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9911022.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc or Duel.SSet(tp,tc)==0 then return end
	local cg=tc:GetColumnGroup()
	cg:AddCard(tc)
	if tc:IsOnField() and cg:IsExists(Card.IsAbleToGrave,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9911022,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=cg:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c9911022.attcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c9911022.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c9911022.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_EARTH)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local ec=re:GetHandler()
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			ec:CancelToGrave()
			Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
		end
	end
end
