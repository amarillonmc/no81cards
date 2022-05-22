--魔导驭傀师 幻视
function c9910905.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910905,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910905)
	e1:SetCondition(c9910905.spcon)
	e1:SetTarget(c9910905.sptg)
	e1:SetOperation(c9910905.spop)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910906)
	e2:SetCondition(c9910905.ctcon)
	e2:SetTarget(c9910905.cttg)
	e2:SetOperation(c9910905.ctop)
	c:RegisterEffect(e2)
end
function c9910905.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c9910905.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910905.cfilter,1,nil,tp)
end
function c9910905.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910905.rafilter1(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c9910905.rafilter2,tp,LOCATION_GRAVE,0,1,nil,c:GetRace())
end
function c9910905.rafilter2(c,race)
	return aux.IsCodeListed(c,9910871) and c:GetRace()>0 and c:GetRace()~=race
end
function c9910905.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
	local dg=Duel.GetOperatedGroup()
	local g=Duel.GetMatchingGroup(c9910905.rafilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if dg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and g:GetCount()>0
		and Duel.SelectYesNo(tp,aux.Stringid(9910905,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc1=g:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910905,2))
		local tc2=Duel.SelectMatchingCard(tp,c9910905.rafilter2,tp,LOCATION_GRAVE,0,1,1,nil,tc1:GetRace()):GetFirst()
		Duel.HintSelection(Group.FromCards(tc1,tc2))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(tc2:GetRace())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1)
	end
end
function c9910905.cfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c9910905.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re)
		and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsExistingMatchingCard(c9910905.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c9910905.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
end
function c9910905.ctop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.GetControl(re:GetHandler(),tp)
	end
end
