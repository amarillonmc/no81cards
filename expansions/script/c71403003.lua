--气泡方块使 I
if not c71403001 then dofile("expansions/script/c71403001.lua") end
function c71403003.initial_effect(c)
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
	ep2:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE)
	ep2:SetType(EFFECT_TYPE_IGNITION)
	ep2:SetCode(EVENT_FREE_CHAIN)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetDescription(aux.Stringid(71403003,0))
	ep2:SetCountLimit(1,71503003)
	ep2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ep2:SetCost(yume.PPTLimitCost)
	ep2:SetTarget(c71403003.tgp2)
	ep2:SetOperation(c71403003.opp2)
	c:RegisterEffect(ep2)
	--monster movement effect
	yume.RegPPTTetrisBasicMoveEffect(c,71403003)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71403003,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,71513003)
	e2:SetCondition(yume.PPTMainPhaseCon)
	e2:SetCost(yume.PPTLimitCost)
	e2:SetTarget(c71403003.tg2)
	e2:SetOperation(c71403003.op2)
	c:RegisterEffect(e2)
	yume.PPTCounter()
end
function c71403003.filterp2a(c)
	return c:GetSequence()>4 and c:IsFaceup() and c:IsSetCard(0x715) and c:IsCanChangePosition()
end
function c71403003.filterp2b(c)
	return c:IsSetCard(0x715) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c71403003.tgp2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c71403003.filterp2a(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71403003.filterp2a,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c71403003.filterp2b,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c71403003.filterp2a,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c71403003.opp2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c71403003.filterp2b,tp,LOCATION_DECK,0,1,nil)
	if tc:IsRelateToEffect(e)
		and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0
		and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c71403003.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=c end
	if chk==0 then return
		c:GetSequence()<5
		and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,c)
		and Duel.GetFieldGroupCount(0,LOCATION_ONFIELD,LOCATION_ONFIELD)>2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c71403003.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and c:GetSequence()<5 and tc:IsRelateToEffect(e)) then return end
	local dg=Group.FromCards(c,tc)
	if Duel.Destroy(dg,REASON_EFFECT)==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end