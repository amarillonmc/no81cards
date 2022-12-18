--吸血鬼魔血 石像肌理
function c9911076.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c9911076.target)
	e1:SetOperation(c9911076.activate)
	c:RegisterEffect(e1)
end
function c9911076.cfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x8e) and c:IsType(TYPE_MONSTER)
end
function c9911076.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and aux.NegateAnyFilter(chkc) end
	local ct=Duel.GetMatchingGroupCount(c9911076.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return ct>0 and Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
end
function c9911076.checkfilter(c)
	return c:IsCode(9911056) and c:IsFaceup()
end
function c9911076.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain():Filter(Card.IsFaceup,nil)
	for tc in aux.Next(g) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
	if not Duel.IsExistingMatchingCard(c9911076.checkfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		local ph=Duel.GetCurrentPhase()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c9911076.skipcon)
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,3)
		else
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c9911076.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
