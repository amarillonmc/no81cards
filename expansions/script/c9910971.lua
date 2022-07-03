--永夏的倾覆
function c9910971.initial_effect(c)
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetOperation(c9910971.flag)
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910971,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e2:SetCountLimit(1,9910971)
	e2:SetCondition(c9910971.poscon)
	e2:SetTarget(c9910971.postg)
	e2:SetOperation(c9910971.posop)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910971,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,9910971)
	e3:SetCondition(c9910971.rtcon)
	e3:SetTarget(c9910971.rttg)
	e3:SetOperation(c9910971.rtop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(9910971,ACTIVITY_CHAIN,c9910971.chainfilter)
end
function c9910971.flag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(9910963,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910963,3))
	end
end
function c9910971.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x5954))
end
function c9910971.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(9910971,tp,ACTIVITY_CHAIN)~=0
end
function c9910971.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c9910971.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9910971.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910971.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9910971.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c9910971.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c9910971.remfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c9910971.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910971.remfilter,1,nil)
end
function c9910971.tgfilter(c)
	return c:IsFacedown() and c:IsSetCard(0x5954) and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT)
end
function c9910971.rttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910971.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function c9910971.rtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c9910971.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,1)
		e1:SetLabel(tc:GetOriginalAttribute())
		e1:SetTarget(c9910971.splimit)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910971.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(e:GetLabel(),c:GetOriginalAttribute())~=0
end
