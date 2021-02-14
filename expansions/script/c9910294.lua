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
	e1:SetCondition(c9910294.condition)
	e1:SetTarget(c9910294.target)
	e1:SetOperation(c9910294.operation)
	c:RegisterEffect(e1)
end
function c9910294.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9910294.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9910294.tgfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave()
end
function c9910294.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c9910294.spfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c9910294.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<4 then return end
	Duel.ConfirmDecktop(tp,4)
	local g=Duel.GetDecktopGroup(tp,4):Filter(Card.IsType,nil,TYPE_PENDULUM)
	if not g:IsExists(c9910294.tgfilter,1,nil) then Duel.ShuffleDeck(tp) return end
	if Duel.GetFlagEffect(tp,9910494)==0 and Duel.SelectYesNo(tp,aux.Stringid(9910294,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg0=g:FilterSelect(tp,c9910294.tgfilter,1,1,nil)
		Duel.SendtoGrave(sg0,REASON_EFFECT)
		g:Sub(sg0)
		Duel.RegisterFlagEffect(tp,9910494,RESET_PHASE+PHASE_END,0,1)
	end
	if Duel.GetFlagEffect(tp,9910494)==0 or g:GetCount()==0 then Duel.ShuffleDeck(tp) return end
	if Duel.GetFlagEffect(tp,9910495)==0 and Duel.SelectYesNo(tp,aux.Stringid(9910294,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910294,3))
		local sg1=g:Select(tp,1,1,nil)
		Duel.SendtoExtraP(sg1,tp,REASON_EFFECT)
		g:Sub(sg1)
		Duel.RegisterFlagEffect(tp,9910495,RESET_PHASE+PHASE_END,0,1)
	end
	if Duel.GetFlagEffect(tp,9910495)==0 or not g:IsExists(c9910294.thfilter,1,nil) then Duel.ShuffleDeck(tp) return end
	if Duel.GetFlagEffect(tp,9910496)==0 and Duel.SelectYesNo(tp,aux.Stringid(9910294,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g:FilterSelect(tp,c9910294.thfilter,1,1,nil)
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg2)
		Duel.ShuffleHand(tp)
		g:Sub(sg2)
		Duel.RegisterFlagEffect(tp,9910496,RESET_PHASE+PHASE_END,0,1)
	end
	if Duel.GetFlagEffect(tp,9910496)==0 or not g:IsExists(c9910294.spfilter,1,nil,e,tp) then Duel.ShuffleDeck(tp) return end
	if Duel.GetFlagEffect(tp,9910497)==0 and Duel.SelectYesNo(tp,aux.Stringid(9910294,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg3=g:FilterSelect(tp,c9910294.spfilter,1,1,nil,e,tp)
		Duel.SpecialSummon(sg3,0,tp,tp,false,false,POS_FACEUP)
		Duel.RegisterFlagEffect(tp,9910497,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.ShuffleDeck(tp)
end
