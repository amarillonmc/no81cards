--雪狱之罪人 深仇
function c9911363.initial_effect(c)
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911363)
	e1:SetCondition(c9911363.spcon1)
	e1:SetCost(c9911363.spcost1)
	e1:SetTarget(c9911363.sptg1)
	e1:SetOperation(c9911363.spop1)
	c:RegisterEffect(e1)
	--spsummon GY
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,9911364)
	e2:SetCondition(c9911363.spcon2)
	e2:SetTarget(c9911363.sptg2)
	e2:SetOperation(c9911363.spop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(9911363,ACTIVITY_CHAIN,c9911363.chainfilter)
end
function c9911363.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0xc956))
end
function c9911363.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(9911363,tp,ACTIVITY_CHAIN)>0 or Duel.GetCustomActivityCount(9911363,1-tp,ACTIVITY_CHAIN)>0
end
function c9911363.cffilter(c)
	return not c:IsPublic()
end
function c9911363.stfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup() and c:IsCanTurnSet()
end
function c9911363.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c9911363.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler())
	local ct=Duel.GetCurrentChain()
	local te=nil
	if ct>1 then te=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT) end
	local b2=te and (te:IsActiveType(TYPE_MONSTER) or te:GetActiveType()==TYPE_SPELL)
		and Duel.IsExistingMatchingCard(c9911363.stfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(9911363,0))) then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ct-1,g)
		Duel.ChangeChainOperation(ct-1,c9911363.repop)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tc=Duel.SelectMatchingCard(tp,c9911363.cffilter,tp,LOCATION_HAND,0,1,1,e:GetHandler()):GetFirst()
		tc:RegisterFlagEffect(9911363,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c9911363.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c9911363.stfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.HintSelection(g)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
function c9911363.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) end
end
function c9911363.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1=c:IsAbleToGrave()
	local b2=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=1191
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=1152
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	if sel==0 then
		Duel.SendtoGrave(c,REASON_EFFECT)
	elseif sel==1 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9911363.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT+REASON_REDIRECT)
end
function c9911363.tgfilter(c,tp,ct)
	return c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>=ct
end
function c9911363.spfilter(c,e,tp)
	return c:IsSetCard(0xc956) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911363.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9911363.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c9911363.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp,1)
		and Duel.IsExistingTarget(c9911363.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local ft=1
	if Duel.IsExistingMatchingCard(c9911363.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9911363.spfilter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c9911363.spop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ct=#g
	if ct>1 and not Duel.IsExistingMatchingCard(c9911363.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp,2) then ct=1 end
	if ct>0 and not Duel.IsExistingMatchingCard(c9911363.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp,1) then ct=0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c9911363.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp,ct):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
		g=g:Filter(Card.IsRelateToEffect,nil,e)
		if #g==0 or (#g>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
		if #g>ft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g=g:Select(tp,ft,ft,nil)
		end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
