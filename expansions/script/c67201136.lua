--神授的百千抉择
function c67201136.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	--e1:SetCountLimit(1,67201136)
	e1:SetCondition(c67201136.condition)
	e1:SetTarget(c67201136.target)
	e1:SetOperation(c67201136.activate)
	c:RegisterEffect(e1)  
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67201136,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,67201136)
	e4:SetCondition(c67201136.spcon)
	e4:SetTarget(c67201136.sptg)
	e4:SetOperation(c67201136.spop)
	c:RegisterEffect(e4)  
end
function c67201136.actcfilter(c)
	return c:IsSetCard(0x3670) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c67201136.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c67201136.actcfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c67201136.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c67201136.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,0,REASON_EFFECT)
	end
end
--
--
function c67201136.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DRAW)
end
function c67201136.spfilter(c,e,tp)
	return c:IsSetCard(0x3670) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67201136.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c67201136.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c67201136.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67201136.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
		if Duel.SSet(tp,c)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(67201136,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end
