--心象风景 倒转
function c19209556.initial_effect(c)
	aux.AddCodeList(c,19209522)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,19209556+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c19209556.condition)
	e1:SetTarget(c19209556.target)
	e1:SetOperation(c19209556.activate)
	c:RegisterEffect(e1)
end
function c19209556.chkfilter(c,tp)
	return c:GetPreviousCodeOnField()==19209522 and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and c:GetReasonPlayer()==1-tp and not c:IsReason(REASON_RULE)
end
function c19209556.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19209556.chkfilter,1,nil,tp)
end
function c19209556.spfilter(c,e,tp)
	return c:IsCode(19209522) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function c19209556.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c19209556.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c19209556.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c19209556.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
		if tc then
			Duel.BreakEffect()
			Duel.HintSelection(Group.FromCards(tc))
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
