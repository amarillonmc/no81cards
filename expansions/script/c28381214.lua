--闪耀的开始
function c28381214.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(4,28381214+EFFECT_COUNT_CODE_OATH)
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
	local g=Duel.SelectMatchingCard(tp,c28381214.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c28381214.tgfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c28381214.spfilter(c,e,tp)
	return c:IsSetCard(0x283) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28381214.ilfilter(c)
	return c:IsSetCard(0x284) and not c:IsPublic()
end
function c28381214.anfilter(c)
	return c:IsSetCard(0x285) and not c:IsPublic()
end
function c28381214.hkfilter(c)
	return c:IsSetCard(0x286) and not c:IsPublic()
end
function c28381214.alfilter(c)
	return c:IsSetCard(0x287) and not c:IsPublic()
end
function c28381214.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28381214.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil)
	if Duel.SendtoHand(tg,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,tg)
	if tc:IsRelateToEffect(e) then Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) end
	local b1=Duel.IsExistingMatchingCard(c28381214.ilfilter,tp,LOCATION_HAND,0,2,nil) and Duel.IsExistingMatchingCard(c28381214.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c28381214.anfilter,tp,LOCATION_HAND,0,2,nil)
	local b3=Duel.IsExistingMatchingCard(c28381214.hkfilter,tp,LOCATION_HAND,0,2,nil) and Duel.IsExistingMatchingCard(c28381214.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b4=Duel.IsExistingMatchingCard(c28381214.alfilter,tp,LOCATION_HAND,0,2,nil)
	if not (b1 or b2 or b3 or b4) then return end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(28381214,0)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(28381214,1)
		opval[off]=1
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(28381214,2)
		opval[off]=2
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(28381214,3)
		opval[off]=3
		off=off+1
	end
	if true then
		ops[off]=aux.Stringid(28381214,4)
		opval[off]=4
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	if sel~=4 then Duel.BreakEffect() end
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c28381214.ilfilter,tp,LOCATION_HAND,0,2,2,nil)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c28381214.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
	elseif sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c28381214.anfilter,tp,LOCATION_HAND,0,2,2,nil)
		Duel.BreakEffect()
		Duel.Damage(tp,500,REASON_EFFECT,true)
		Duel.Damage(1-tp,500,REASON_EFFECT,true)
		Duel.RDComplete()
	elseif sel==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c28381214.hkfilter,tp,LOCATION_HAND,0,2,2,nil)
		Duel.BreakEffect()
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c28381214.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	elseif sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c28381214.alfilter,tp,LOCATION_HAND,0,2,2,nil)
		Duel.BreakEffect()
		Duel.Recover(tp,500,REASON_EFFECT)
	end
end
