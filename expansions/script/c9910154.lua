--战车道装甲·巡洋十字军
require("expansions/script/c9910106")
function c9910154.initial_effect(c)
	--xyz summon
	Zcd.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),3,2,c9910154.xyzfilter,aux.Stringid(9910154,0),99)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910154,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910154)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9910154.thcost)
	e1:SetTarget(c9910154.thtarget)
	e1:SetOperation(c9910154.thoperation)
	c:RegisterEffect(e1)
end
function c9910154.xyzfilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x952) and c:IsFaceup()))
		and c:IsRace(RACE_MACHINE)
end
function c9910154.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c9910154.thtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)
		and (c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) or c:IsAbleToRemove()) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9910154.thoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g1:GetCount()==0 then return end
	Duel.HintSelection(g1)
	if Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g2:GetCount()==0 then return end
	Duel.HintSelection(g2)
	if Duel.SendtoHand(g2,nil,REASON_EFFECT)==0 then return end
	if c:IsRelateToEffect(e) then
		local b1=c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
		local b2=c:IsAbleToRemove()
		if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(9910154,2),aux.Stringid(9910154,3))==0) then
			Duel.BreakEffect()
			c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		elseif b2 then
			Duel.BreakEffect()
			Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(c)
			e1:SetCountLimit(1)
			e1:SetOperation(c9910154.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c9910154.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
