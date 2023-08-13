--再拾的永夏 鹰原羽依里
function c9910967.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910967)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910967.sptg)
	e1:SetOperation(c9910967.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,9910977)
	e2:SetTarget(c9910967.thtg)
	e2:SetOperation(c9910967.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c9910967.rmfilter(c)
	return c:IsSetCard(0x5954) and c:IsAbleToRemove()
end
function c9910967.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9910967.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9910967.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)
		and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910967.rmfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		local res=tc:IsLocation(LOCATION_HAND)
		if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and res and tc:IsLocation(LOCATION_REMOVED) then
			local tg=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,0,nil,0x6954,1)
			if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910967,0)) then
				for tc in aux.Next(tg) do
					tc:AddCounter(0x6954,1)
				end
			end
		end
	end
end
function c9910967.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3
		and Duel.GetDecktopGroup(tp,3):FilterCount(Card.IsAbleToHand,nil)>0 end
	Duel.SetTargetPlayer(tp)
end
function c9910967.thfilter(c)
	return c:IsSetCard(0x5954) and c:IsAbleToHand()
end
function c9910967.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	local tg=g:Filter(c9910967.thfilter,nil)
	if #tg>0 and Duel.SelectYesNo(p,aux.Stringid(9910967,1)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=tg:Select(p,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,sg)
	end
	Duel.ShuffleDeck(p)
end
