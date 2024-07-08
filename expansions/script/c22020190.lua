--人理之基 泳装尼禄
function c22020190.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xff1),1)
	c:EnableReviveLimit()
	--summon success
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c22020190.sumcon)
	e0:SetOperation(c22020190.sumsuc)
	c:RegisterEffect(e0)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(22020130)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020190,1))
	e2:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,22020190)
	e2:SetTarget(c22020190.cointg)
	e2:SetOperation(c22020190.coinop)
	c:RegisterEffect(e2)
	--coin
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22020190,2))
	e3:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22020190)
	e3:SetCondition(c22020190.erescon)
	e3:SetCost(c22020190.erecost)
	e3:SetTarget(c22020190.cointg)
	e3:SetOperation(c22020190.coinop)
	c:RegisterEffect(e3)
end
function c22020190.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c22020190.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SelectOption(tp,aux.Stringid(22020190,0))
end
function c22020190.thfilter(c)
	return aux.IsCodeListed(c,22020130) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c22020190.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c22020190.coinop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	local c1,c2,c3=Duel.TossCoin(tp,3)
	if c1+c2+c3==0 then
		Duel.SelectOption(tp,aux.Stringid(22020190,3))
	end
	if c1+c2+c3>=1 then
		Duel.SelectOption(tp,aux.Stringid(22020190,4))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,tp)
	end
	if c1+c2+c3>=2 then
		Duel.SelectOption(tp,aux.Stringid(22020190,5))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,tp)
	end
	if c1+c2+c3==3 and sg:GetCount()>0 then
		Duel.SelectOption(tp,aux.Stringid(22020190,6))
		Duel.SelectOption(tp,aux.Stringid(22020190,7))
		local sg=Duel.GetMatchingGroup(c22020190.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c22020190.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22020190.erescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22020190.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end