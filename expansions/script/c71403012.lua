--气泡方块使 J&L
if not c71403001 then dofile("expansions/script/c71403001.lua") end
function c71403012.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--scale
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_SINGLE)
	ep1:SetCode(EFFECT_CHANGE_LSCALE)
	ep1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetCondition(yume.PPTOtherScaleCheck)
	ep1:SetValue(13)
	c:RegisterEffect(ep1)
	local ep1a=ep1:Clone()
	ep1a:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(ep1a)
	--change pos
	local ep2=Effect.CreateEffect(c)
	ep2:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND+CATEGORY_SEARCH)
	ep2:SetType(EFFECT_TYPE_IGNITION)
	ep2:SetCode(EVENT_FREE_CHAIN)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetDescription(aux.Stringid(71403012,0))
	ep2:SetCountLimit(1,71503012)
	ep2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ep2:SetCost(yume.PPTLimitCost)
	ep2:SetTarget(c71403012.tgp2)
	ep2:SetOperation(c71403012.opp2)
	c:RegisterEffect(ep2)
	--monster movement effect
	yume.RegPPTTetrisBasicMoveEffect(c,71403012)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71403012,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,71513004)
	e2:SetCondition(yume.PPTMainPhaseCon)
	e2:SetCost(yume.PPTLimitCost)
	e2:SetTarget(c71403012.tg2)
	e2:SetOperation(c71403012.op2)
	c:RegisterEffect(e2)
	yume.PPTCounter()
end
function c71403012.filterp2a(c)
	return c:GetSequence()>4 and c:IsFaceup() and c:IsSetCard(0x715) and c:IsCanChangePosition()
end
function c71403012.filterp2b(c)
	return c:IsSetCard(0x715) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c71403012.tgp2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c71403012.filterp2a(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71403012.filterp2a,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c71403012.filterp2b,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c71403012.filterp2a,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71403012.opp2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c71403012.filterp2b,tp,LOCATION_GRAVE,0,1,nil)
	if tc:IsRelateToEffect(e)
		and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0
		and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71403001,1))
		local g=Duel.SelectMatchingCard(tp,c71403012.filterp2b,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c71403012.filter2des(c,tp,tc)
	return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,Group.FromCards(c,tc))
end
function c71403012.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=c and c71403012.filter2des(chkc,c) end
	if chk==0 then
		return c:GetSequence()<5 and Duel.IsExistingTarget(c71403012.filter2des,tp,LOCATION_ONFIELD,0,1,c,tp,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c71403012.filter2des,tp,LOCATION_ONFIELD,0,1,1,c,tp,c)
	g:AddCard(c)
	local g2=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g2,1,0,0)
end
function c71403012.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and c:GetSequence()<5 and tc:IsRelateToEffect(e)) then return end
	local dg=Group.FromCards(c,tc)
	if Duel.Destroy(dg,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			local sc=g:GetFirst()
			Duel.NegateRelatedChain(sc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			sc:RegisterEffect(e3)
			if sc:IsType(TYPE_TRAPMONSTER) then
				local e1=e2:Clone()
				e1:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				sc:RegisterEffect(e1)
			end
		end
	end
end