--扩散性镜碎·皓
function c188845.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcab),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Atk
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(c188845.valop)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(188845,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c188845.con)
	e1:SetTarget(c188845.thtg)
	e1:SetOperation(c188845.thop)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(188845,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,188845)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c188845.target)
	e2:SetOperation(c188845.operation)
	c:RegisterEffect(e2)
end
c188845.counter_add_list={0x10cb}
function c188845.counterfilter(c)
	return c:IsSetCard(0xcab) and ((c:IsPublic() and c:IsLocation(LOCATION_HAND)) or (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)))
end
function c188845.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=0
	local ct=Duel.GetMatchingGroupCount(c188845.counterfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,nil)
	if chkc then return chkc:IsCanAddCounter(0x10cb,ct+1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x10cb,ct+1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x10cb,ct+1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct+1,0,0)
end
function c188845.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) and c:IsPublic() then return false end
	local ct=Duel.GetMatchingGroupCount(c188845.counterfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,nil)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsCanAddCounter(0x10cb,ct+1) then
		tc:AddCounter(0x10cb,ct+1)
		Duel.RaiseEvent(tc,EVENT_CUSTOM+54306223,e,0,0,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c188845.distarget)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		--disable effect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetOperation(c188845.disoperation)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c188845.distarget(e,c)
	local ct=c:GetCounter(0x10cb)
	return ct>=5
end
function c188845.disoperation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():GetCounter(0x10cb)>=5 then
		Duel.NegateEffect(ev)
	end
end
function c188845.valop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_SYNCHRO) then return end
	local g=c:GetMaterial()
	local atk=g:GetCount()*1000
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
end
function c188845.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c188845.thfilter(c)
	return c:IsSetCard(0xcab) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c188845.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c188845.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c188845.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c188845.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end

