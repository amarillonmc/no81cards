--气泡方块的淘气双子 J&L
if not c71403001 then dofile("expansions/script/c71403001.lua") end
---@param c Card
function c71403015.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsXyzType,TYPE_PENDULUM),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--damage
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ep1:SetCode(EVENT_SPSUMMON_SUCCESS)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetProperty(EFFECT_FLAG_DELAY)
	ep1:SetCondition(c71403015.damcon)
	ep1:SetOperation(c71403015.damop)
	c:RegisterEffect(ep1)
	--change pos
	local ep2=Effect.CreateEffect(c)
	ep2:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
	ep2:SetType(EFFECT_TYPE_IGNITION)
	ep2:SetCode(EVENT_FREE_CHAIN)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetDescription(aux.Stringid(71403015,0))
	ep2:SetCountLimit(1,71503015)
	ep2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ep2:SetCost(yume.PPTLimitCost)
	ep2:SetTarget(c71403015.tgp2)
	ep2:SetOperation(c71403015.opp2)
	c:RegisterEffect(ep2)
	--monster movement effect
	yume.RegPPTTetrisExMoveEffect(c,71403015)
	--disable and remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71403015,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCountLimit(1,71513015)
	e2:SetCost(yume.PPTLimitCost)
	e2:SetTarget(c71403015.tg2)
	e2:SetOperation(c71403015.op2)
	c:RegisterEffect(e2)
	yume.PPTCounter()
end
c71403015.pendulum_level=4
function c71403015.damcon(e,tp,eg,ep,ev,re,r,rp)
	return yume.PPTOtherScaleCheck(e) and eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_PENDULUM)
end
function c71403015.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,71403015)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c71403015.tgp2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanChangePosition() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanChangePosition,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tg=Duel.SelectTarget(tp,Card.IsCanChangePosition,0,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,#tg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c71403015.opp2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)
		and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			local c=e:GetHandler()
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
function c71403015.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		return c:CheckRemoveOverlayCard(tp,2,REASON_EFFECT)
			and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			or Duel.IsExistingMatchingCard(c71403015.filter2,tp,LOCATION_ONFIELD,0,1,nil,true)
	end
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c71403015.filter2(c,check)
	return c:IsFaceup() and c:IsSetCard(0x715)
		and (not check or Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c))
end
function c71403015.filter2dis(c,e)
	return aux.NegateAnyFilter(c) and c:IsCanBeDisabledByEffect(e)
end
function c71403015.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt1=c:IsRelateToEffect(e) and c:CheckRemoveOverlayCard(tp,2,REASON_EFFECT)
	local opt2=Duel.IsExistingMatchingCard(c71403015.filter2,tp,LOCATION_ONFIELD,0,1,nil,false)
	local result=0
	if not opt1 and not opt2 then return end
	if opt1 and not opt2 then result=0 end
	if opt2 and not opt1 then result=1 end
	if opt1 and opt2 then result=Duel.SelectOption(tp,aux.Stringid(71403011,2),aux.Stringid(71403011,3)) end
	if result==0 then
		result=c:RemoveOverlayCard(tp,2,2,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c71403015.filter2,tp,LOCATION_ONFIELD,0,1,1,nil,false)
		Duel.HintSelection(dg)
		result=Duel.Destroy(dg,REASON_EFFECT)
	end
	if result==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,c71403015.filter2dis,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil,e)
	if g:GetCount()==0 then return end
	for sc in aux.Next(g) do
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
	local bg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tp)
	if bg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71403015,4)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sbg=bg:Select(tp,1,2,nil)
		Duel.Remove(sbg,POS_FACEUP,REASON_EFFECT)
	end
end