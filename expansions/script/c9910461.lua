--韶光的怀恋 希尔维娅
function c9910461.initial_effect(c)
	c:EnableCounterPermit(0x950)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--add counter & to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_TOHAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c9910461.ctcon)
	e1:SetTarget(c9910461.cttg)
	e1:SetOperation(c9910461.ctop)
	c:RegisterEffect(e1)
	--recover & draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetOperation(c9910461.regop)
	c:RegisterEffect(e2)
end
function c9910461.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9910461.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x950,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x950)
end
function c9910461.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:AddCounter(0x950,1) and Duel.GetCounter(tp,1,0,0x950)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910461,0)) then
		Duel.BreakEffect()
		local ct=Duel.GetCounter(tp,1,0,0x950)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c9910461.regop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetLabel(lp)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910461.rccon)
	e1:SetOperation(c9910461.rcop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910461.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)~=e:GetLabel()
end
function c9910461.rcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910461)
	if Duel.GetLP(tp)<e:GetLabel() then
		local s=Duel.Recover(tp,e:GetLabel()-Duel.GetLP(tp),REASON_EFFECT)
		local d=math.floor(s/2000)
		if d>0 then Duel.Draw(tp,d,REASON_EFFECT) end
	else
		Duel.SetLP(tp,e:GetLabel())
	end
end
