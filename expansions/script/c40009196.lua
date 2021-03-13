--时机变换
function c40009196.initial_effect(c)
	c:EnableCounterPermit(0xf1c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40009196+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1) 
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c40009196.ctcon)
	e2:SetOperation(c40009196.ctop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009196,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(c40009196.spcon1)
	e3:SetTarget(c40009196.destg)
	e3:SetOperation(c40009196.desop)
	c:RegisterEffect(e3) 
	local e6=e3:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMING_END_PHASE)
	e6:SetCost(c40009196.nnegcost)
	e6:SetCondition(c40009196.spcon2)
	c:RegisterEffect(e6)	
	--atk/def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetValue(c40009196.val)
	c:RegisterEffect(e5)
end
function c40009196.nnegcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xf1c,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xf1c,3,REASON_COST)
end
function c40009196.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,40009208) or (Duel.GetCurrentChain()<1 and Duel.IsPlayerAffectedByEffect(tp,40009208))
end
function c40009196.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0 and Duel.IsPlayerAffectedByEffect(tp,40009208)
end
function c40009196.ctfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xf1c) and c:IsControler(tp)
end
function c40009196.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40009196.ctfilter,1,nil,tp)
end
function c40009196.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xf1c,2)
end
function c40009196.val(e,c)
	--return e:GetHandler():GetCounter(0xf1c)*100
	return Duel.GetCounter(0,1,1,0xf1c)*100
end
function c40009196.desfilter(c)
	return c:IsFaceup()
end
function c40009196.thfilter(c)
	return c:IsSetCard(0xf1c) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c40009196.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c40009196.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c40009196.desfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c40009196.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c40009196.desfilter,tp,LOCATION_PZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c40009196.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=Duel.SelectMatchingCard(tp,c40009196.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		local g=sg:GetFirst()
		if g then
			Duel.MoveToField(g,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
