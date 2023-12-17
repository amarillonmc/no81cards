--虹彩偶像的激昂
function c9910393.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910393+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910393.condition)
	e1:SetTarget(c9910393.target)
	e1:SetOperation(c9910393.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9910393,ACTIVITY_CHAIN,c9910393.chainfilter1)
	Duel.AddCustomActivityCounter(9910394,ACTIVITY_CHAIN,c9910393.chainfilter2)
end
function c9910393.chainfilter1(re,tp,cid)
	return not (re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x5951))
end
function c9910393.chainfilter2(re,tp,cid)
	return not (re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsType(TYPE_FIELD))
end
function c9910393.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(9910393,tp,ACTIVITY_CHAIN)~=0
end
function c9910393.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c9910393.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c9910393.distg1)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c9910393.discon)
	e2:SetOperation(c9910393.disop)
	e2:SetLabel(ac)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c9910393.distg2)
	e3:SetLabel(ac)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	if c:IsFaceup() and c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.GetCustomActivityCount(9910394,tp,ACTIVITY_CHAIN)~=0 then
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9910393,0))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCondition(c9910393.drcon)
		e1:SetOperation(c9910393.drop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c9910393.distg1(e,c)
	local ac=e:GetLabel()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsOriginalCodeRule(ac)
	else
		return c:IsOriginalCodeRule(ac) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function c9910393.distg2(e,c)
	local ac=e:GetLabel()
	return c:IsOriginalCodeRule(ac)
end
function c9910393.discon(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	return re:GetHandler():IsOriginalCodeRule(ac)
end
function c9910393.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c9910393.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return c:GetFlagEffect(9910393)==0 and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and g and g:IsContains(c)
		and Duel.IsPlayerCanDraw(tp,1)
end
function c9910393.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(9910393,1)) then
		Duel.Hint(HINT_CARD,0,9910393)
		Duel.Draw(tp,1,REASON_EFFECT)
		c:RegisterFlagEffect(9910393,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910393,2))
	end
end
