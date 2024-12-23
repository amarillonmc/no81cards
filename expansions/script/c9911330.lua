--胧之渺翳的雠怼
function c9911330.initial_effect(c)
	--Activate material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911330,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911330+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911330.target1)
	e1:SetOperation(c9911330.activate1)
	c:RegisterEffect(e1)
	--Activate disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911330,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,9911330+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c9911330.condition)
	e2:SetTarget(c9911330.target2)
	e2:SetOperation(c9911330.activate2)
	c:RegisterEffect(e2)
	--Activate both
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9911330,2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,9911330+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c9911330.condition)
	e3:SetTarget(c9911330.target3)
	e3:SetOperation(c9911330.activate3)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9911330,3))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_EQUIP)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,9911331)
	e4:SetTarget(c9911330.settg)
	e4:SetOperation(c9911330.setop)
	c:RegisterEffect(e4)
end
function c9911330.xmfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND) and c:IsType(TYPE_XYZ)
end
function c9911330.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsCanOverlay(tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,nil,tp)
		and Duel.IsExistingMatchingCard(c9911330.xmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
end
function c9911330.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c9911330.xmfilter,tp,LOCATION_MZONE,0,1,nil) and tc:IsCanOverlay(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,c9911330.xmfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(tg)
		if tg:GetFirst():IsImmuneToEffect(e) then return end
		local og=tc:GetOverlayGroup()
		if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
		tc:CancelToGrave()
		Duel.Overlay(tg:GetFirst(),Group.FromCards(tc))
	end
end
function c9911330.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) or rp~=1-tp then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0xa958) and p==tp
end
function c9911330.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9911330.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c9911330.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsCanOverlay(tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,nil,tp)
		and Duel.IsExistingMatchingCard(c9911330.xmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9911330.activate3(e,tp,eg,ep,ev,re,r,rp)
	local chk
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e)
		and Duel.IsExistingMatchingCard(c9911330.xmfilter,tp,LOCATION_MZONE,0,1,nil) and tc:IsCanOverlay(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,c9911330.xmfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(tg)
		if not tg:GetFirst():IsImmuneToEffect(e) then
			local og=tc:GetOverlayGroup()
			if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
			tc:CancelToGrave()
			Duel.Overlay(tg:GetFirst(),Group.FromCards(tc))
		end
		chk=true
	end
	if chk then Duel.BreakEffect() end
	Duel.NegateEffect(ev)
end
function c9911330.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c9911330.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SSet(tp,c) end
end
