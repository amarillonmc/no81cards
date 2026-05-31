--异晶人的炸弹
function c71280014.initial_effect(c)
	aux.AddCodeList(c,2061963)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71280014)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c71280014.condition)
	e1:SetTarget(c71280014.target)
	e1:SetOperation(c71280014.activate)
	c:RegisterEffect(e1)
	--
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabelObject(e0)
	e2:SetCountLimit(1,11280014)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c71280014.spcon)
	e2:SetTarget(c71280014.sptg)
	e2:SetOperation(c71280014.spop)
	c:RegisterEffect(e2)
end
function c71280014.filter(c)
	local no=aux.GetXyzNumber(c)
	return no and no>=101 and no<=107 and c:IsSetCard(0x48) and c:IsType(TYPE_XYZ)
end
function c71280014.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c71280014.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c71280014.sfilter(c)
	return c:IsCode(57734012) and (c:IsFaceup() or c:IsLocation(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE))
end
function c71280014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71280014.sfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c71280014.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71280014.sfilter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		local tc=g:Select(tp,1,1,nil):GetFirst()	
		Duel.SendtoDeck(tc,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_DECK) then return end
		Duel.ShuffleDeck(1-tp)
		tc:ReverseInDeck()
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DRAW)
		e1:SetOperation(c71280014.xop)
		e1:SetReset(RESET_EVENT+0x1de0000)
		tc:RegisterEffect(e1)
	end
end
function c71280014.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	Duel.Damage(tp,1000,REASON_EFFECT)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct>=7 then
		local rg=Duel.GetDecktopGroup(tp,7):Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	elseif ct>0 then
		local rg=Duel.GetDecktopGroup(tp,ct):Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c71280014.cfilter(c,tp,se)
	return c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_MZONE)
		and (se==nil or c:GetReasonEffect()~=se)
end
function c71280014.spfilter(c,e,tp)
	return c:IsCode(2061963) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71280014.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(c71280014.cfilter,1,c,tp,se)
end
function c71280014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71280014.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c71280014.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280014.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c71280014.thfilter1),tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c71280014.thfilter2),tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(71280014,0)) then
		Duel.BreakEffect()
		local tc1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280014.thfilter1),tp,LOCATION_GRAVE,0,1,1,nil)
		local tc2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280014.thfilter2),tp,LOCATION_GRAVE,0,1,1,nil)
		tc2:Merge(tc1)
		Duel.SendtoHand(tc2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc2)
	end
end
function c71280014.thfilter1(c)
	return c:IsSetCard(0x176) and c:IsAbleToHand()
end
function c71280014.thfilter2(c)
	return c:IsType(TYPE_XYZ) and c:IsAbleToHand()
end