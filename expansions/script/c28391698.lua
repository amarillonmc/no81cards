--闪耀的战歌 染空
function c28391698.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28391698,0))
	e1:SetHintTiming(TIMING_BATTLE_END,0)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,28391698)
	e1:SetCondition(c28391698.necon)
	e1:SetTarget(c28391698.netg)
	e1:SetOperation(c28391698.neop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28391698,1))
	e2:SetHintTiming(0,TIMING_SUMMON+TIMING_SPSUMMON+TIMING_BATTLE_END)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,28391698)
	e2:SetCondition(c28391698.decon)
	e2:SetTarget(c28391698.detg)
	e2:SetOperation(c28391698.deop)
	c:RegisterEffect(e2)
	--dye the sky
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28391698,4))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,38391698)
	e3:SetTarget(c28391698.dtstg)
	e3:SetOperation(c28391698.dtsop)
	c:RegisterEffect(e3)
end
function c28391698.cfilter(c)
	return c:IsSetCard(0x283) and c:IsFaceup()
end
function c28391698.necon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c28391698.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28391698.cfilter,tp,LOCATION_MZONE,0,2,nil) and
		Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local bpchk=0
	if Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<PHASE_BATTLE then bpchk=1 end
	e:SetLabel(bpchk)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end
function c28391698.neop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
	local ct=math.floor(Duel.GetMatchingGroupCount(c28391698.cfilter,tp,LOCATION_MZONE,0,nil)/2)
	if #g==0 or ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local og=Group.Select(g,tp,1,ct,nil)
	local tc=og:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=og:GetNext()
	end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28391698,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c28391698.decon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c28391698.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28391698.cfilter,tp,LOCATION_MZONE,0,2,nil) and
		Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	local bpchk=0
	if Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<PHASE_BATTLE then bpchk=1 end
	e:SetLabel(bpchk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c28391698.deop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local ct=math.floor(Duel.GetMatchingGroupCount(c28391698.cfilter,tp,LOCATION_MZONE,0,nil)/2)
	if #g==0 or ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local dg=Group.Select(g,tp,1,ct,nil)
	Duel.HintSelection(dg)
	Duel.Destroy(dg,REASON_EFFECT)
	local og=Duel.GetOperatedGroup():Filter(Card.IsAbleToRemove,nil,tp)
	if e:GetLabel()==1 and #og>0 and Duel.SelectYesNo(tp,aux.Stringid(28391698,3)) then
		Duel.BreakEffect()
		Duel.Remove(og,POS_FACEUP,REASON_EFFECT)
	end
end
function c28391698.dtstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c28391698.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28391698.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c28391698.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c28391698.dtsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local att=tc:GetAttribute()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(att)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
