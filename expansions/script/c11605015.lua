--反裂界机兵·辉光翼
function c11605015.initial_effect(c)
	c:SetSPSummonOnce(11605015)
	--spsummon itself
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11605015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(c11605015.condition)
	e1:SetTarget(c11605015.spstg)
	e1:SetOperation(c11605015.spsop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1193)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c11605015.condition)
	e2:SetTarget(c11605015.tdtg)
	e2:SetOperation(c11605015.tdop)
	c:RegisterEffect(e2)
	--spsummon other
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11605015,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,11605015)
	e3:SetTarget(c11605015.sptg)
	e3:SetOperation(c11605015.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11605015,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,11605015)
	e4:SetCondition(c11605015.spcon)
	e4:SetTarget(c11605015.sptg)
	e4:SetOperation(c11605015.spop)
	c:RegisterEffect(e4)
	c11605015.todeck_effect=e4
end
function c11605015.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c11605015.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11605015.cfilter,1,nil)
end
function c11605015.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11605015.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11605015.tdfilter(c)
	return c:IsAbleToDeck() and c:IsFaceup()
end
function c11605015.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11605015.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
end
function c11605015.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c11605015.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c11605015.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_REMOVED)
end
function c11605015.spfilter(c)
	return c:IsSetCard(0xa224) and c:IsLevelBelow(4)
end
function c11605015.sfilter1(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0
		and g:IsExists(c11605015.sfilter2,1,c,e,tp)
end
function c11605015.sfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.GetMZoneCount(1-tp)>0
end
function c11605015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c11605015.spfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and g:IsExists(c11605015.sfilter1,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,PLAYER_ALL,LOCATION_DECK)
end
function c11605015.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11605015.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND,0,nil)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:IsExists(c11605015.sfilter1,1,nil,e,tp,g) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11605015,2))
		local sc=g:FilterSelect(tp,c11605015.sfilter1,1,1,nil,e,tp,g):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11605015,3))
		local oc=g:FilterSelect(tp,c11605015.sfilter2,1,1,sc,e,tp):GetFirst()
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2)
		Duel.SpecialSummonStep(oc,0,tp,1-tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		oc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		oc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
