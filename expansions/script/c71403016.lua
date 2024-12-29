--气泡方块的千金与管家 S&Z
if not c71403001 then dofile("expansions/script/c71403001.lua") end
function c71403016.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsXyzType,TYPE_PENDULUM),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--inactivatable
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_FIELD)
	ep1:SetCode(EFFECT_CANNOT_DISABLE)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetTargetRange(LOCATION_MZONE,0)
	ep1:SetCondition(yume.PPTOtherScaleCheck)
	ep1:SetTarget(c71403016.indtg)
	ep1:SetValue(c71403016.efilter)
	c:RegisterEffect(ep1)
	local ep1a=Effect.CreateEffect(c)
	ep1a:SetType(EFFECT_TYPE_FIELD)
	ep1a:SetCode(EFFECT_CANNOT_DISEFFECT)
	ep1a:SetRange(LOCATION_PZONE)
	ep1a:SetTargetRange(LOCATION_MZONE,0)
	ep1a:SetCondition(yume.PPTOtherScaleCheck)
	ep1a:SetTarget(c71403016.indtg)
	ep1a:SetValue(c71403016.efilter)
	c:RegisterEffect(ep1a)
	--change pos
	local ep2=Effect.CreateEffect(c)
	ep2:SetCategory(CATEGORY_POSITION)
	ep2:SetType(EFFECT_TYPE_IGNITION)
	ep2:SetCode(EVENT_FREE_CHAIN)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetDescription(aux.Stringid(71403016,0))
	ep2:SetCountLimit(1,71503016)
	ep2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ep2:SetCost(yume.PPTLimitCost)
	ep2:SetTarget(c71403016.tgp2)
	ep2:SetOperation(c71403016.opp2)
	c:RegisterEffect(ep2)
	--monster movement effect
	yume.RegPPTTetrisExMoveEffect(c,71403016)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71403016,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOEXTRA+CATEGORY_DESTROY+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCountLimit(1,71513016)
	e2:SetCost(yume.PPTLimitCost)
	e2:SetTarget(c71403016.tg2)
	e2:SetOperation(c71403016.op2)
	c:RegisterEffect(e2)
	yume.PPTCounter()
end
c71403016.pendulum_level=4
function c71403016.indtg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x715) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c71403016.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c71403016.tgp2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanChangePosition() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tg=Duel.SelectTarget(tp,Card.IsCanChangePosition,0,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,#tg,0,0)
end
function c71403016.opp2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)
		and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			for sc in aux.Next(g) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(71403016,4))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetRange(LOCATION_MZONE)
				e1:SetCondition(c71403016.immcon)
				e1:SetValue(c71403016.efilter)
				e1:SetOwnerPlayer(tp)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CONTROL)
				sc:RegisterEffect(e1)
			end
		end
	end
end
function c71403016.immcon(e)
	return e:GetHandler():IsControler(e:GetOwnerPlayer())
end
function c71403016.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		return (c:CheckRemoveOverlayCard(tp,2,REASON_EFFECT)
			and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			or Duel.IsExistingMatchingCard(c71403016.filter2,tp,LOCATION_ONFIELD,0,1,nil,true))
			and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_PENDULUM)
	end
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(c71403016.filter2a,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g2,1,0,0)
end
function c71403016.filter2(c,check)
	return c:IsFaceup() and c:IsSetCard(0x715)
		and (not check or Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c))
end
function c71403016.filter2a(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x715)
end
function c71403016.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt1=c:IsRelateToEffect(e) and c:CheckRemoveOverlayCard(tp,2,REASON_EFFECT)
	local opt2=Duel.IsExistingMatchingCard(c71403016.filter2,tp,LOCATION_ONFIELD,0,1,nil,false)
	local result=0
	if not opt1 and not opt2 then return end
	if opt1 and not opt2 then result=0 end
	if opt2 and not opt1 then result=1 end
	if opt1 and opt2 then result=Duel.SelectOption(tp,aux.Stringid(71403011,2),aux.Stringid(71403011,3)) end
	if result==0 then
		result=c:RemoveOverlayCard(tp,2,2,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c71403016.filter2,tp,LOCATION_ONFIELD,0,1,1,nil,false)
		Duel.HintSelection(dg)
		result=Duel.Destroy(dg,REASON_EFFECT)
	end
	if result==0 then return end
	local dg=Duel.GetMatchingGroup(c71403016.filter2a,tp,LOCATION_GRAVE,0,1,nil)
	local ct=2
	if dg:GetCount()==1 then
		ct=1
	elseif dg:GetCount()==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	g=Duel.GetOperatedGroup()
	ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		local sdg=dg:Select(tp,1,ct,nil)
		Duel.SendtoExtraP(sdg,nil,REASON_EFFECT)
	end
end