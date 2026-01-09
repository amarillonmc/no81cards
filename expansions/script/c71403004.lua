--气泡方块使 S
---@param c Card
function c71403004.initial_effect(c)
	if not (yume and yume.PPT_loaded) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71403001,0)
		yume.import_flag=false
	end
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--scale
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_SINGLE)
	ep1:SetCode(EFFECT_CHANGE_LSCALE)
	ep1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetCondition(yume.PPTOtherScaleCheck)
	ep1:SetValue(0)
	c:RegisterEffect(ep1)
	local ep1a=ep1:Clone()
	ep1a:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(ep1a)
	--change pos
	local ep2=Effect.CreateEffect(c)
	ep2:SetCategory(CATEGORY_POSITION+CATEGORY_TOEXTRA)
	ep2:SetType(EFFECT_TYPE_IGNITION)
	ep2:SetCode(EVENT_FREE_CHAIN)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetDescription(aux.Stringid(71403004,0))
	ep2:SetCountLimit(1,71503004)
	ep2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ep2:SetCost(yume.PPTLimitCost)
	ep2:SetTarget(c71403004.tgp2)
	ep2:SetOperation(c71403004.opp2)
	c:RegisterEffect(ep2)
	--monster movement effect
	yume.RegPPTTetrisBasicMoveEffect(c,71403004)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71403004,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,71513004)
	e1:SetCondition(yume.PPTMainPhaseCon)
	e1:SetCost(yume.PPTLimitCost)
	e1:SetTarget(c71403004.tg1)
	e1:SetOperation(c71403004.op1)
	c:RegisterEffect(e1)
	yume.PPTCounter()
end
function c71403004.filterp2a(c)
	return c:GetSequence()>4 and c:IsFaceup() and c:IsSetCard(0x715) and c:IsCanChangePosition()
end
function c71403004.filterp2b(c)
	return c:IsSetCard(0x715) and c:IsType(TYPE_PENDULUM)
end
function c71403004.tgp2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c71403004.filterp2a(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71403004.filterp2a,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c71403004.filterp2b,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c71403004.filterp2a,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c71403004.opp2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c71403004.filterp2b,tp,LOCATION_DECK,0,1,nil)
	if tc:IsRelateToEffect(e)
		and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0
		and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71403001,1))
		local g=Duel.SelectMatchingCard(tp,c71403004.filterp2b,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoExtraP(g,nil,REASON_EFFECT)
		end
	end
end
function c71403004.filter1(c)
	return c:IsSetCard(0x715) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToHand()
end
function c71403004.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return
		chkc:IsOnField() and chkc:IsControler(tp) and chkc~=c
	end
	local pg=Duel.GetMatchingGroup(c71403004.filter1,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then
		return (c:GetSequence()<5 or c:IsLocation(LOCATION_HAND))
		and pg:GetCount()>0
		and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,c)
	if c:IsLocation(LOCATION_MZONE) then
		g:AddCard(c)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,pg,1,tp,LOCATION_EXTRA)
end
function c71403004.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local c_is_in_hand=c:IsLocation(LOCATION_HAND)
	if not (c:IsRelateToEffect(e) and (c_is_in_hand or c:GetSequence()<5)) then return end
	local op_flag=false
	if c_is_in_hand then
		op_flag=Duel.SendtoExtraP(c,nil,REASON_EFFECT)>0 and c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()
	else
		op_flag=Duel.Destroy(c,REASON_EFFECT)==1
	end
	if not op_flag then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.BreakEffect()
	if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71403004.filter1,tp,LOCATION_EXTRA,0,1,2,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end