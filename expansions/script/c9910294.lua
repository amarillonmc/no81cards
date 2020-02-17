--风暴星幽使 伊势琴里
function c9910294.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_PENDULUM),2,2)
	--to extra & to hand & spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9910294)
	e1:SetCondition(c9910294.condition)
	e1:SetTarget(c9910294.target)
	e1:SetOperation(c9910294.operation)
	c:RegisterEffect(e1)
end
function c9910294.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9910294.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9910294.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c9910294.spfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c9910294.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 and g:IsExists(Card.IsType,1,nil,TYPE_PENDULUM)
		and Duel.SelectYesNo(tp,aux.Stringid(9910294,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910294,3))
		local sg1=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_PENDULUM)
		Duel.SendtoExtraP(sg1,tp,REASON_EFFECT)
		g:Sub(sg1)
		if g:GetCount()>0 and g:IsExists(c9910294.thfilter,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9910294,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg2=g:FilterSelect(tp,c9910294.thfilter,1,1,nil)
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg2)
			Duel.ShuffleHand(tp)
			g:Sub(sg2)
			if g:GetCount()>0 and g:IsExists(c9910294.spfilter,1,nil,e,tp)
				and Duel.SelectYesNo(tp,aux.Stringid(9910294,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg3=g:FilterSelect(tp,c9910294.spfilter,1,1,nil,e,tp)
				Duel.SpecialSummon(sg3,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	Duel.ShuffleDeck(tp)
end
