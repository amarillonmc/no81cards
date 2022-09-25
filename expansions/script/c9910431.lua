--赛博空间逃脱
function c9910431.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9910431)
	e2:SetCost(c9910431.discost)
	e2:SetTarget(c9910431.distg)
	e2:SetOperation(c9910431.disop)
	c:RegisterEffect(e2)
	--remove/to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,9910430)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c9910431.tdtg)
	e3:SetOperation(c9910431.tdop)
	c:RegisterEffect(e3)
end
function c9910431.cfilter(c)
	return c:IsSetCard(0x6950) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
		and c:IsAbleToRemoveAsCost()
end
function c9910431.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910431.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c9910431.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
end
function c9910431.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.NegateEffectMonsterFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c9910431.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if not tc:IsDisabled() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
function c9910431.filter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
		and (c:IsAbleToRemove() or c:IsAbleToDeck())
end
function c9910431.gselect(g)
	return #g==1 or g:IsExists(Card.IsAbleToRemove,2,nil) or g:IsExists(Card.IsAbleToDeck,2,nil)
end
function c9910431.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c9910431.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,e:GetHandler(),e)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c9910431.filter(chkc,e) end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g:SelectSubGroup(tp,c9910431.gselect,false,1,2)
	Duel.SetTargetCard(tg)
end
function c9910431.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if aux.NecroValleyNegateCheck(tg) then return end
	if tg:GetCount()>0 then
		local b1=tg:FilterCount(Card.IsAbleToRemove,nil)==#tg
		local b2=tg:FilterCount(Card.IsAbleToDeck,nil)==#tg
		local opt=-1
		if b1 and not b2 then
			opt=Duel.SelectOption(tp,1192)
		elseif not b1 and b2 then
			opt=Duel.SelectOption(tp,aux.Stringid(9910431,0))+1
		elseif b1 and b2 then
			opt=Duel.SelectOption(tp,1192,aux.Stringid(9910431,0))
		end
		if opt==0 then
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		elseif opt==1 then
			Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
