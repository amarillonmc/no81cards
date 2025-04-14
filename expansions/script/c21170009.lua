--天启录H
function c21170009.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21170009+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21170009.tg)
	e1:SetOperation(c21170009.op)
	c:RegisterEffect(e1)
	c21170009.copy = e1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21170009,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1)
	e2:SetTarget(c21170009.tg2)
	e2:SetOperation(c21170009.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c21170009.con3)
	e3:SetOperation(c21170009.op3)
	c:RegisterEffect(e3)	
end
function c21170009.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(c21170009.q,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c21170009.q(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x6917)
end
function c21170009.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c21170009.q,tp,LOCATION_HAND,0,1,2,nil)
	if #g<=0 then return end
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	local s=Duel.GetOperatedGroup():GetCount()
	if s<=0 then return end
	s = s + 1
	local dg=Duel.GetDecktopGroup(tp,s)
		if Duel.Draw(tp,#g+1,REASON_EFFECT) then
			for tc in aux.Next(dg) do
				if tc:IsLocation(2) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1,true)
				end
			end
		end
	end
end
function c21170009.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c21170009.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-600)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		end
	end
end
function c21170009.con3(e,tp,eg,ep,ev,re,r,rp)
	return r&(REASON_LINK|REASON_FUSION|REASON_SYNCHRO)>0
end
function c21170009.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsSetCard(0x6917) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21170009,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1)
	e1:SetOwnerPlayer(ep)
	e1:SetTarget(c21170009.tg2)
	e1:SetOperation(c21170009.op2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1)
end