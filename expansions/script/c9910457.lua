--韶光歌后 玛丽亚·毕肖普
function c9910457.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9950),c9910457.matfilter,2,63,true)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c9910457.ctcon)
	e1:SetTarget(c9910457.cttg)
	e1:SetOperation(c9910457.ctop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,9910457)
	e2:SetCondition(c9910457.regcon)
	e2:SetOperation(c9910457.regop)
	c:RegisterEffect(e2)
end
function c9910457.matfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsFusionType(TYPE_EFFECT)
end
function c9910457.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c9910457.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	if chk==0 then return ct>0 and c:IsCanAddCounter(0x1950,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x1950)
end
function c9910457.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	if ct>0 and c:IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1950,ct)
	end
end
function c9910457.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9910457.regop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetLabel(lp)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910457.rccon)
	e1:SetOperation(c9910457.rcop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	Duel.RegisterEffect(e1,tp)
end
function c9910457.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)~=e:GetLabel()
end
function c9910457.rcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910457)
	if Duel.GetLP(tp)<e:GetLabel() then
		local s=Duel.Recover(tp,e:GetLabel()-Duel.GetLP(tp),REASON_EFFECT)
		local d=math.floor(s/2000)
		if d<=0 then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(c9910457.negcon)
		e1:SetOperation(c9910457.negop)
		e1:SetLabel(d)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		if d>5 then d=6 end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(9910457,d))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetTargetRange(1,1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	else
		Duel.SetLP(tp,e:GetLabel())
	end
end
function c9910457.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,9910457)<e:GetLabel()
end
function c9910457.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(9910457,0)) then return end
	Duel.Hint(HINT_CARD,0,9910457)
	Duel.RegisterFlagEffect(tp,9910457,RESET_PHASE+PHASE_END,0,1)
	Duel.NegateEffect(ev)
end
