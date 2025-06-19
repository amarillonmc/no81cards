--浩瀚生态的物种调查
function c9911230.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911230+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9911230.cost)
	e1:SetTarget(c9911230.target)
	e1:SetOperation(c9911230.activate)
	c:RegisterEffect(e1)
end
function c9911230.costfilter(c)
	return c:IsSetCard(0x5958) and c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c9911230.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911230.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9911230.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9911230.ckfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c9911230.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() and chkc~=e:GetHandler() end
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c9911230.ckfilter,tp,LOCATION_MZONE,0,nil)
	local op=0
	if ct>0 and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then
		op=Duel.SelectOption(tp,aux.Stringid(9911230,0),aux.Stringid(9911230,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9911230,1))+1
	end
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,e:GetHandler())
		e:SetOperation(c9911230.activate)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(c9911230.activate2)
	end
end
function c9911230.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c9911230.activate2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c9911230.tntg)
	e1:SetValue(TYPE_TUNER)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9911230.tntg(e,c)
	return c:IsLevelAbove(4)
end
