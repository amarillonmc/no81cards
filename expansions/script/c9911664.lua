--岭偶殖构体·孽生
function c9911664.initial_effect(c)
	--Activate only search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911664,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911664+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911664.target1)
	e1:SetOperation(c9911664.activate1)
	c:RegisterEffect(e1)
	--Activate remove/spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911664,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,9911664+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c9911664.condition)
	e2:SetTarget(c9911664.target2)
	e2:SetOperation(c9911664.activate2)
	c:RegisterEffect(e2)
	if not c9911664.global_check then
		c9911664.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c9911664.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911664.checkfilter(c,tp)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c9911664.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c9911664.checkfilter,1,nil,0) and Duel.GetFlagEffect(0,9911654)==0 then
		Duel.RegisterFlagEffect(0,9911654,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(9911654,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,0)
	end
	if eg:IsExists(c9911664.checkfilter,1,nil,1) and Duel.GetFlagEffect(1,9911654)==0 then
		Duel.RegisterFlagEffect(1,9911654,RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(9911654,2))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,1)
	end
end
function c9911664.thtgfilter(c)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c9911664.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c9911664.thtgfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
end
function c9911664.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911664.thtgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.ConfirmCards(1-tp,sg)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
	end
end
function c9911664.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,9911654)==0 then return false end
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		local b1=tc:IsAbleToRemove(tp,POS_FACEDOWN)
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		if te:IsActiveType(TYPE_MONSTER) and tc:IsRelateToEffect(te) and (b1 or b2) then
			return true
		end
	end
	return false
end
function c9911664.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=0
	local g=Duel.GetMatchingGroup(c9911664.thtgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		op=Duel.SelectOption(tp,aux.Stringid(9911664,1),aux.Stringid(9911664,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9911664,1))
	end
	e:SetLabel(op)
	local cate=0
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		local b1=tc:IsAbleToRemove(tp,POS_FACEDOWN)
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		if te:IsActiveType(TYPE_MONSTER) and tc:IsRelateToEffect(te) and (b1 or b2) and tc:IsLocation(LOCATION_GRAVE) then
			cate=CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON
		end
	end
	if op==0 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+cate)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+cate)
	end
end
function c9911664.activate2(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local chk
	if op==1 then
		local g=Duel.GetMatchingGroup(c9911664.thtgfilter,tp,LOCATION_DECK,0,nil)
		if g:GetClassCount(Card.GetCode)>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
			Duel.ConfirmCards(1-tp,sg)
			local tg=sg:RandomSelect(1-tp,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local tc=tg:Select(tp,1,1,nil):GetFirst()
			if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
				tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
			Duel.ShuffleDeck(tp)
			chk=true
		end
	end
	local g=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		local b1=tc:IsAbleToRemove(tp,POS_FACEDOWN)
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and not aux.NecroValleyNegateCheck(tc)
		if te:IsActiveType(TYPE_MONSTER) and tc:IsRelateToEffect(te) and (b1 or b2) then
			g:AddCard(tc)
		end
	end
	if #g==0 then return end
	if chk then Duel.BreakEffect() end
	if g:IsExists(Card.IsFacedown,1,nil) then
		local cg=g:Filter(Card.IsFacedown,nil)
		Duel.ConfirmCards(tp,cg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	local sc=sg:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not sc:IsAbleToRemove(tp,POS_FACEDOWN) or Duel.SelectOption(tp,1192,1152)==1) then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Remove(sc,POS_FACEDOWN,REASON_EFFECT)
	end
end
