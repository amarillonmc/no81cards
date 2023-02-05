--白蛇阴阳师 瑞灵
local m=30005125
local cm=_G["c"..m] 
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_REPTILE),8,2,nil,nil,75)
	c:EnableReviveLimit()
	--Effect 1
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_GRAVE_SPSUMMON+CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.discon)
	e2:SetCost(cm.discost)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	--Effect 3 
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e12:SetCode(EVENT_RELEASE)
	e12:SetTarget(cm.thtg)
	e12:SetOperation(cm.thop)
	c:RegisterEffect(e12) 
end
--Effect 1
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcs=Duel.GetFirstTarget()
	if tcs:IsRelateToEffect(e) 
		and Duel.SendtoGrave(tcs,REASON_EFFECT)>0
		and Duel.SelectYesNo(1-tp,aux.Stringid(m,4)) then
		local g=Duel.GetMatchingGroup(cm.ft,tp,0,LOCATION_DECK,nil)
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.sp),tp,0,LOCATION_GRAVE,nil,e,tp)
		local b1=#g>0
		local b2=#sg>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(m,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(m,1)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(1-tp,table.unpack(ops))
		if opval[op]==1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local tcc=g:Select(1-tp,1,1,nil):GetFirst()
			if tcc and Duel.SendtoGrave(tcc,REASON_EFFECT)>0 
				and tcc:IsLocation(LOCATION_GRAVE) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetRange(LOCATION_GRAVE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tcc:RegisterEffect(e1)
				tcc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5)) 
			end
		elseif opval[op]==2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local ag=sg:FilterSelect(1-tp,aux.NecroValleyFilter(cm.sp),1,1,nil,e,tp)
			local tc=ag:GetFirst()
			if Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.ft(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function cm.sp(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,1-tp,false,false) 
end
--Effect 2
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.sp2(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) 
		and c:IsRace(RACE_REPTILE) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and cm.sp2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.sp2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.sp2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--Effect 3
function cm.t(c)
	return c:IsAbleToDeck() and c:IsRace(RACE_REPTILE)
end 
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.t,tp,LOCATION_GRAVE,0,1,c) and c:IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 
		and c:IsLocation(LOCATION_EXTRA)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.t),tp,LOCATION_GRAVE,0,1,c) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.t),tp,LOCATION_GRAVE,0,1,5,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end



  