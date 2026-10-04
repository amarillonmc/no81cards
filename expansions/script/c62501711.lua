--蚀痕无命 露丝塔娜
function c62501711.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)--TIMING_END_PHASE
	e1:SetDescription(aux.Stringid(62501711,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,62501711)
	e1:SetCost(c62501711.spcost)
	e1:SetTarget(c62501711.sptg)
	e1:SetOperation(c62501711.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)--TIMING_END_PHASE
	e2:SetDescription(aux.Stringid(62501711,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,62501711+1)
	e2:SetTarget(c62501711.rmtg)
	e2:SetOperation(c62501711.rmop)
	c:RegisterEffect(e2)
	--remove&to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SSET+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,62501711+2)
	e4:SetTarget(c62501711.thtg)
	e4:SetOperation(c62501711.thop)
	c:RegisterEffect(e4)
	c62501711.remove_event_effect=e4
end
function c62501711.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 or e:GetHandler():IsAbleToRemove(tp,POS_FACEDOWN) end
	if #g==3 then
		Duel.DisableShuffleCheck()
	end
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.HintSelection(Group.FromCards(e:GetHandler()))
	else
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c62501711.spfilter(c,e,tp,chk)
	return c:IsSetCard(0xea4) and not c:IsCode(62501711) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsFacedown() or not c:IsLocation(LOCATION_REMOVED))
end
function c62501711.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501711.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c62501711.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c62501711.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c62501711.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	g:AddCard(e:GetHandler())
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==#g end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,tp,0)
end
function c62501711.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,3)
	local c=e:GetHandler()
	if not g or #g==0 or not c:IsRelateToChain() or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	g:AddCard(c)
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil,tp,POS_FACEDOWN)
	if #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(62501711,1)) then
		Duel.BreakEffect()
		local tc=rg:RandomSelect(tp,1):GetFirst()
		if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			tc:RegisterFlagEffect(62501711,RESET_EVENT+RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabelObject(tc)
			e1:SetCondition(c62501711.retcon)
			e1:SetOperation(c62501711.retop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c62501711.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(62501711)==0 then
		e:Reset()
		return false
	else
		return true
	end
end
function c62501711.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
end
function c62501711.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==#g end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,tp,0)
end
function c62501711.setfilter(c)
	return c:IsSetCard(0xea4) and c:IsFacedown() and (c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsSSetable())
end
function c62501711.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,3)
	local c=e:GetHandler()
	if not g or #g==0 or Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	if Duel.IsExistingMatchingCard(c62501711.setfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(62501711,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,c62501711.setfilter,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
			if tc:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(62501711,3))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			if tc:IsType(TYPE_TRAP) then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(62501711,3))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end
