--结天缘姬 紧急撤退
function c67200323.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200323,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c67200323.condition)
	e2:SetTarget(c67200323.target)
	e2:SetOperation(c67200323.operation)
	c:RegisterEffect(e2)
end
--
function c67200323.actfilter(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function c67200323.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
		and Duel.IsExistingMatchingCard(c67200323.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c67200323.filter(c,e,tp)
	return c:IsSetCard(0x671) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200323.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,1-tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 and #g1>0 and Duel.IsExistingMatchingCard(c67200323.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	g:Merge(g1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c67200323.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,1-tp,0,LOCATION_MZONE,1,1,nil)
	g:Merge(g1)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local gg=Duel.SelectMatchingCard(tp,c67200323.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
			if gg:GetCount()>0 then
				Duel.SpecialSummon(gg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

