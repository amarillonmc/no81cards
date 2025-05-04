--曙龙生息之星河
function c9910819.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes by effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_RITUAL))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--spsummon/search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910819,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+9910819)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,9910819)
	e3:SetTarget(c9910819.spthtg)
	e3:SetOperation(c9910819.spthop)
	c:RegisterEffect(e3)
	aux.RegisterMergedDelayedEvent(c,9910819,EVENT_TO_GRAVE)
end
function c9910819.spfilter(c,e,tp,lv)
	return c:GetLevel()<lv and c:IsSetCard(0x6951) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c9910819.thfilter1(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910819.thfilter2(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c9910819.spthfilter(c,e,tp)
	local b1=c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910819.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel())
	local b2=c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c9910819.thfilter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c9910819.thfilter2,tp,LOCATION_DECK,0,1,nil)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_DISCARD)
		and c:IsCanBeEffectTarget(e) and (b1 or b2)
end
function c9910819.spthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:FilterCount(c9910819.spthfilter,nil,e,tp)>0 end
	local tg
	if #eg==1 then
		tg=eg:Clone()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tg=eg:FilterSelect(tp,c9910819.spthfilter,1,1,nil,e,tp)
	end
	Duel.SetTargetCard(tg)
end
function c9910819.spthop(e,tp,eg,ep,ev,re,r,rp)
	local res=0
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c9910819.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetLevel())
		if #sg>0 then
			res=Duel.SpecialSummon(sg,0,tp,tp,false,true,POS_FACEUP)
		end
	end
	if tc:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsExistingMatchingCard(c9910819.thfilter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c9910819.thfilter2,tp,LOCATION_DECK,0,1,nil) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg1=Duel.SelectMatchingCard(tp,c9910819.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg2=Duel.SelectMatchingCard(tp,c9910819.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		tg1:Merge(tg2)
		if #tg1>0 and Duel.SendtoHand(tg1,nil,REASON_EFFECT)>0 and tg1:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tg1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tg3=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
			tg3:AddCard(tc)
			if tg3:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoDeck(tg3,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end
