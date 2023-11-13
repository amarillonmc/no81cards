--黄泉之宴
function c67200626.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1) 
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,67200626)
	e5:SetTarget(c67200626.tgtg)
	e5:SetOperation(c67200626.tgop)
	c:RegisterEffect(e5)  
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c67200626.handcon)
	c:RegisterEffect(e2)  
end
function c67200626.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c67200626.setfilter(c)
	return c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function c67200626.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local gg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if gg:GetCount()>0 then
		Duel.HintSelection(gg)
		Duel.SendtoGrave(gg,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(c67200626.setfilter,tp,LOCATION_DECK,0,nil)
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0
		and Duel.SelectYesNo(tp,aux.Stringid(67200626,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:Select(tp,1,1,nil)
			Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
--
function c67200626.handcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetTurnPlayer()==tp
end
