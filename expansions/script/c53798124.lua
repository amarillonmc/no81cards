local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,s.matfilter,nil,nil,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--activate trap in set turn
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.acttg)
	c:RegisterEffect(e1)
	--to hand & set & banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_TOGRAVE+TIMING_END_PHASE)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.colfilter(c,tp)
	return c:IsControler(tp) and c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.matfilter(c,syncard)
	return c:IsTuner(syncard) or c:GetColumnGroup():IsExists(s.colfilter,1,nil,c:GetControler())
end
function s.acttg(e,c)
	return c:IsType(TYPE_CONTINUOUS)
end
function s.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function s.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_HAND,0,nil)
		local bg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tp,POS_FACEDOWN)
		if #g>0 and #bg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(tp,1,1,nil)
			if Duel.SSet(tp,sg,tp,false)~=0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local rg=bg:Select(tp,1,1,nil)
				Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
end