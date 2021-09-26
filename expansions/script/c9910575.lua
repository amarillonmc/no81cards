--混合咖啡的恋心调制
function c9910575.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910575+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910575.cost)
	e1:SetTarget(c9910575.target)
	e1:SetOperation(c9910575.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9910575,ACTIVITY_CHAIN,c9910575.chainfilter)
end
function c9910575.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (re:IsActiveType(TYPE_MONSTER) and not rc:IsLocation(LOCATION_MZONE)
		and rc:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK))
end
function c9910575.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(9910575,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(c9910575.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910575.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsLocation(LOCATION_MZONE)
		and rc:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)
end
function c9910575.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(9910575,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(9910575,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(9910575,0),aux.Stringid(9910575,1))
	end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c9910575.spfilter(c,e,tp)
	return c:IsSetCard(0xc951) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c9910575.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()==0 then return end
		Duel.HintSelection(g)
		if Duel.ChangePosition(g:GetFirst(),POS_FACEUP_DEFENSE)==0 then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g2=Duel.GetMatchingGroup(c9910575.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910575,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g2:Select(tp,1,1,nil)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g:GetFirst(),POS_FACEDOWN_DEFENSE)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(3)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
