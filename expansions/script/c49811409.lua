--三重奏奏鸣曲-神龙曲-
function c49811409.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,49811409+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c49811409.activate)
	c:RegisterEffect(e1)
	--select
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811409,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_TODECK+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c49811409.condition)
	e2:SetTarget(c49811409.target)
	e2:SetOperation(c49811409.operation)
	c:RegisterEffect(e2)
end
function c49811409.spfilter(c,e,sp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsDefense(1100) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c49811409.activate(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(c49811409.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if #cg>0 and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(49811409,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=cg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c49811409.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c49811409.tdfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON) and c:IsAbleToDeck()
end
function c49811409.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON) and c:IsAbleToGrave()
end
function c49811409.exfilter(c,tp)
	local b1=c:IsType(TYPE_FUSION) and Duel.GetFlagEffect(tp,49811409)==0
		and Duel.IsExistingMatchingCard(c49811409.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b2=c:IsType(TYPE_SYNCHRO) and Duel.GetFlagEffect(tp,49811410)==0
		and Duel.IsExistingMatchingCard(c49811409.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
	local b3=c:IsType(TYPE_XYZ) and Duel.GetFlagEffect(tp,49811411)==0
		and Duel.IsExistingMatchingCard(c49811409.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	return c:IsRace(RACE_DRAGON) and c:IsFaceup() and (b1 or b2 or b3)
end
function c49811409.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811409.exfilter,1,nil,tp)
end
function c49811409.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c49811409.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c49811409.exfilter,nil,tp)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=sg:GetFirst()
	if not tc then return end
	if #sg>1 then
		tc=sg:Select(tp,1,1,nil)
	end
	if tc:IsType(TYPE_FUSION) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811409.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
		Duel.RegisterFlagEffect(tp,49811409,RESET_PHASE+PHASE_END,0,1)
	elseif tc:IsType(TYPE_SYNCHRO) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811409.tdfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,49811410,RESET_PHASE+PHASE_END,0,1)
	elseif tc:IsType(TYPE_XYZ) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c49811409.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,49811411,RESET_PHASE+PHASE_END,0,1)
	end
end
