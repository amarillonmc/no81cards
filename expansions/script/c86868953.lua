--武神器-九拳
function c86868953.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86868953,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,86868955)
	e1:SetTarget(c86868953.thtg)
	e1:SetOperation(c86868953.thop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86868953,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,86868953)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c86868953.target)
	e2:SetOperation(c86868953.activate)
	c:RegisterEffect(e2)
	--tograve replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_DECK)
	e3:SetCountLimit(1,86868954)
	e3:SetTarget(c86868953.reptg2)
	e3:SetOperation(c86868953.repop2)
	e3:SetValue(c86868953.repval2)
	c:RegisterEffect(e3)
end
function c86868953.thfilter(c)
	return c:IsSetCard(0x88) and c:IsAbleToHand()
end
function c86868953.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c86868953.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c86868953.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c86868953.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c86868953.tgfilter(c)
	return c:IsSetCard(0x88) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c86868953.repfilter2(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsSetCard(0x88) and c:IsType(TYPE_MONSTER)
		and c:GetDestination()==LOCATION_GRAVE 
end
function c86868953.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() and eg:IsExists(c86868953.repfilter2,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(86868953,1)) then
		Duel.ConfirmCards(1-tp,eg:Filter(c86868953.repfilter2,nil))
		return true
	else return false end
end
function c86868953.repop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)~=0 then
		local sg=Duel.GetMatchingGroup(c86868953.tgfilter,tp,LOCATION_DECK,0,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=sg:Select(tp,1,1,nil)
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end
function c86868953.repval2(e,c)
	return c:IsLocation(LOCATION_HAND) and c:IsSetCard(0x88) and c:IsType(TYPE_MONSTER)
end
function c86868953.filter(c,e,tp,tc)
	return c:IsSetCard(0x88) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c86868953.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2)
end
function c86868953.mfilter1(c,mg,exg)
	return mg:IsExists(c86868953.mfilter2,1,c,c,exg)
end
function c86868953.mfilter2(c,mc,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end
function c86868953.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c86868953.filter,tp,LOCATION_REMOVED,0,e:GetHandler(),e,tp)
	local exg=Duel.GetMatchingGroup(c86868953.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.GetLocationCountFromEx(tp)>0
		and mg:IsExists(c86868953.mfilter1,1,nil,mg,exg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c86868953.mfilter1,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c86868953.mfilter2,1,1,tc1,tc1,exg)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c86868953.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c86868953.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c86868953.filter2,nil,e,tp)
	if g:GetCount()<2 then return end
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if Duel.GetLocationCountFromEx(tp,tp,g)<=0 then return end
		local xyzg=Duel.GetMatchingGroup(c86868953.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,g)
		end
	end
end