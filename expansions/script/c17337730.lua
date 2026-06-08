--尤里乌斯·尤克里乌斯
function c17337730.initial_effect(c)
	aux.AddCodeList(c,17337400)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3f51),nil,nil,c17337730.mfilter,1,283)
	c:EnableReviveLimit()
	--attr
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17337730,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,17337730)
	e1:SetCondition(c17337730.icon)
	e1:SetCost(c17337730.attrcost)
	--e1:SetTarget(c17337730.attrtg)
	e1:SetOperation(c17337730.attrop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c17337730.qcon)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17337730,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,17337730)
	e3:SetCondition(c17337730.icon)
	e3:SetTarget(c17337730.rmtg)
	e3:SetOperation(c17337730.rmop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c17337730.qcon)
	c:RegisterEffect(e4)
end
function c17337730.mfilter(c,syncard)
	return c:IsTuner(syncard) or c:IsCode(17337400)
end
function c17337730.icon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.IsPlayerAffectedByEffect(tp,17337721)~=nil and e:GetHandler():IsOriginalSetCard(0x3f51))
end
function c17337730.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,17337721)~=nil and e:GetHandler():IsOriginalSetCard(0x3f51)
end
function c17337730.costfilter(c)
	return c:IsSetCard(0x3f50,0x3f51) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function c17337730.pfilter(c,ec)
	return c:IsType(TYPE_MONSTER) and c:IsNonAttribute(ec:GetAttribute()) and not c:IsPublic()
end
function c17337730.attrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c17337730.costfilter,tp,LOCATION_ONFIELD,0,1,c) and Duel.IsExistingMatchingCard(c17337730.pfilter,tp,LOCATION_HAND,0,1,nil,c) end
	--to hand
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,c17337730.costfilter,tp,LOCATION_ONFIELD,0,1,1,c):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_COST)
	--confirm
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetMatchingGroup(c17337730.pfilter,tp,LOCATION_HAND,0,nil,c)
	local sg=g:SelectSubGroup(tp,aux.dabcheck,false,1,#g)
	local att=0
	for tc in aux.Next(sg) do att=bit.bor(att,tc:GetAttribute()) end
	e:SetLabel(att)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c17337730.disfilter(c,ec)
	return aux.NegateMonsterFilter(c) and c:IsAttribute(ec:GetAttribute())
end
function c17337730.attrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		--
		local g=Duel.GetMatchingGroup(c17337730.disfilter,tp,0,LOCATION_MZONE,nil,c)
		if #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(17337730,2)) then return end
		Duel.BreakEffect()
		for tc in aux.Next(g) do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE_EFFECT)
			e1:SetValue(RESET_TURN_SET)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function c17337730.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c17337730.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
