--闪耀的开始
function c28381214.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c28381214.thcost)
	e1:SetTarget(c28381214.thtg)
	e1:SetOperation(c28381214.thop)
	c:RegisterEffect(e1)
end
function c28381214.cfilter(c)
	return c:IsSetCard(0x283) and not c:IsPublic() and c:IsAbleToDeck()
end
function c28381214.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c28381214.thfilter(c)
	return c:IsSetCard(0x284,0x285,0x286,0x287) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28381214.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c28381214.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c28381214.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c28381214.cfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28381214,5))
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c28381214.tgfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c28381214.spfilter(c,e,tp)
	return c:IsSetCard(0x283) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c28381214.chkfilter(c,code)
	return c:IsSetCard(code) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c28381214.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28381214.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil)
	if #tg~=2 or Duel.SendtoHand(tg,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,tg)
	if tc:IsRelateToEffect(e) then Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) end
	local b1=Duel.IsExistingMatchingCard(c28381214.chkfilter,tp,LOCATION_HAND,0,2,nil,0x284)
		and Duel.IsExistingMatchingCard(c28381214.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c28381214.chkfilter,tp,LOCATION_HAND,0,2,nil,0x285)
	local b3=Duel.IsExistingMatchingCard(c28381214.chkfilter,tp,LOCATION_HAND,0,2,nil,0x286)
		and Duel.IsExistingMatchingCard(c28381214.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b4=Duel.IsExistingMatchingCard(c28381214.chkfilter,tp,LOCATION_HAND,0,2,nil,0x287)
	if not (b1 or b2 or b3 or b4) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(28381214,0)},
		{b2,aux.Stringid(28381214,1)},
		{b3,aux.Stringid(28381214,2)},
		{b4,aux.Stringid(28381214,3)},
		{true,aux.Stringid(28381214,4)})
	if op~=5 then c28381214.confirm(tp,op) end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c28381214.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #tg>0 then Duel.SendtoGrave(tg,REASON_EFFECT) end
	elseif op==2 then
		Duel.Damage(tp,1000,REASON_EFFECT,true)
		Duel.Damage(1-tp,1000,REASON_EFFECT,true)
		Duel.RDComplete()
	elseif op==3 then
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c28381214.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #sg>0 then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
	elseif op==4 then
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
function c28381214.confirm(tp,op)
	Duel.ShuffleHand(tp)
	local code=op==1 and 0x284 or op==2 and 0x285 or op==3 and 0x286 or op==4 and 0x287
	local g=Duel.GetMatchingGroup(c28381214.chkfilter,tp,LOCATION_HAND,0,nil,code)
	if #g>2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		g=g:Select(tp,2,2,nil)
	end
	Duel.ConfirmCards(1-tp,g)
	--Duel.ShuffleHand(tp)
end
