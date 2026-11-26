--闪耀的一等星 樱木真乃
function c28315548.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--illumination spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28315548,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28315548)
	e1:SetCondition(c28315548.icon)
	e1:SetTarget(c28315548.sptg)
	e1:SetCost(c28315548.cost)
	e1:SetOperation(c28315548.spop)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c28315548.qcon)
	c:RegisterEffect(e0)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28315548,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	--e2:SetCountLimit(1,28315548+1)
	e2:SetCost(c28315548.thcost)
	e2:SetTarget(c28315548.thtg)
	e2:SetOperation(c28315548.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c28315548.icon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.IsPlayerAffectedByEffect(tp,28361833)~=nil and e:GetHandler():IsOriginalSetCard(0x283))
end
function c28315548.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,28361833)~=nil and e:GetHandler():IsOriginalSetCard(0x283)
end
function c28315548.tdfilter(c)
	return c:IsFaceupEx() and c:IsAbleToDeck()--c:IsType(TYPE_MONSTER+TYPE_SPELL) and 
end
function c28315548.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc,exc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c28315548.tdfilter(chkc) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(c28315548.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,exc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c28315548.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c28315548.lvfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelAbove(1) and c:IsFaceup()
end
function c28315548.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetsRelateToChain()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		local lg=Duel.GetMatchingGroup(c28315548.lvfilter,tp,LOCATION_MZONE,0,nil)
		if not Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) or lg:GetClassCount(Card.GetLevel)==1 or not Duel.SelectYesNo(tp,aux.Stringid(28315548,3)) then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(28315548,4))
		local tc=lg:Select(tp,1,1,nil):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		local g=lg:Filter(aux.NOT(Card.IsLevel),nil,tc:GetLevel())
		local lv=g:GetFirst():GetLevel()
		if g:GetClassCount(Card.GetLevel)>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(28315548,7))
			local sc=g:Select(tp,1,1,nil):GetFirst()
			lv=sc:GetLevel()
		end
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CHANGE_LEVEL)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetValue(lv)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e0)
	end
end
function c28315548.costfilter(c)
	return c:IsCode(28335405) and c:IsAbleToGraveAsCost()
end
function c28315548.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28315548.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28315548.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local ct=g:GetFirst():IsLocation(LOCATION_HAND) and 283 or 0
	e:SetLabel(ct)
	Duel.SendtoGrave(g,REASON_COST)
end
function c28315548.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28315548.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc,exc)
	if chk==0 then return Duel.IsExistingMatchingCard(c28315548.thfilter,tp,LOCATION_DECK,0,1,exc) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28315548.ofilter(e)
	local ct=#c28315548.effect_list
	if (e:IsHasRange(LOCATION_ONFIELD) or (e:GetCode()==EVENT_SUMMON_SUCCESS or e:GetCode()==EVENT_SPSUMMON_SUCCESS or e:GetCode()==EVENT_FLIP) and (e:GetType()&EFFECT_TYPE_SINGLE)~=0) and e:IsActivated() then c28315548.effect_list[ct+1]=e end
	return false--e:IsHasRange(LOCATION_ONFIELD) and e:IsActivated()
end
function c28315548.cpfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER)) then return false end
	c28315548.effect_list={}
	c:IsOriginalEffectProperty(c28315548.ofilter)
	for _,te in ipairs(c28315548.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	end
	return false
end
function c28315548.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c28315548.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if not tg or #tg==0 then return end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	if not Duel.IsExistingMatchingCard(c28315548.cpfilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp) or e:GetLabel()~=283 or not Duel.SelectYesNo(tp,aux.Stringid(28315548,2)) then e:SetLabel(0) return end
	e:SetLabel(0)
	--
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c28315548.cpfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	c28315548.effect_list={}
	tc:IsOriginalEffectProperty(c28315548.ofilter)
	local e_list={}
	for _,te in ipairs(c28315548.effect_list) do
		local tg=te:GetTarget()
		local check=true
		for _,ce in ipairs(e_list) do--compare
			if ce:GetDescription()==te:GetDescription() then check=false break end
		end
		if check and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c28315548.effect_list,i) end
	end
	if #e_list==0 then return end
	local te=e_list[1]
	if #e_list>1 then
		local des_list={}
		for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
		local op=Duel.SelectOption(tp,table.unpack(des_list))
		te=e_list[op+1]
	end
	c28315548.effect_list={}
	--copy
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(EFFECT_FLAG_DELAY)--Original Property
end
function c28315548.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFlagEffectLabel(tp,28315548) or 0
	ct=ct|e:GetLabel()
	if ct==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,28315548,RESET_PHASE+PHASE_END,0,1,ct)
	else
		Duel.SetFlagEffectLabel(tp,28315548,ct)
	end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+28318749,e,0,0,0,0)
end
