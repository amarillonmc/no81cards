--向光捷径
function c82567854.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,82567854),LOCATION_SZONE)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--no followers 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82567854,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCost(c82567854.cost)
	e1:SetCondition(c82567854.con1)
	e1:SetTarget(c82567854.tg1)
	e1:SetOperation(c82567854.op1)
	c:RegisterEffect(e1)
	--only shining 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567854,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c82567854.con2)
	e2:SetTarget(c82567854.tg2)
	e2:SetOperation(c82567854.op2)
	c:RegisterEffect(e2)
	--only nearl 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82567854,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(c82567854.cost)
	e3:SetCondition(c82567854.con3)
	e3:SetTarget(c82567854.tg3)
	e3:SetOperation(c82567854.op3)
	c:RegisterEffect(e3)
	--only nightingale 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567854,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCost(c82567854.cost)
	e4:SetCondition(c82567854.con4)
	e4:SetTarget(c82567854.tg4)
	e4:SetOperation(c82567854.op4)
	c:RegisterEffect(e4)
	--shining & nearl 
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82567854,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCondition(c82567854.con5)
	e5:SetTarget(c82567854.tg5)
	e5:SetOperation(c82567854.op5)
	c:RegisterEffect(e5)
	--shining & nightingale
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(82567854,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e6:SetCondition(c82567854.con6)
	e6:SetTarget(c82567854.tg6)
	e6:SetOperation(c82567854.op6)
	c:RegisterEffect(e6)
	--nearl & nightingale
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(82567854,0))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e7:SetCondition(c82567854.con7)
	e7:SetTarget(c82567854.tg7)
	e7:SetOperation(c82567854.op7)
	c:RegisterEffect(e7)
	--3 followers
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(82567854,0))
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e8:SetCondition(c82567854.con8)
	e8:SetTarget(c82567854.tg8)
	e8:SetOperation(c82567854.op8)
	c:RegisterEffect(e8)	
	--selfdes
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(82567854,2))
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(c82567854.descon)
	e9:SetTarget(c82567854.destg)
	e9:SetOperation(c82567854.desop)
	c:RegisterEffect(e9)
	--cannot destroy (shining)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_SZONE)
	e10:SetCondition(c82567854.con9)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	--cannot be target (nearl)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCondition(c82567854.con10)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	--sanctuary (nightingale)
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(82567854,1))
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_SZONE)
	e12:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMING_BATTLE_START+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_MAIN_END+TIMING_SUMMON+TIMING_SPSUMMON+TIMINGS_CHECK_MONSTER)
	e12:SetCountLimit(1)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetCondition(c82567854.con11)
	e12:SetTarget(c82567854.tg11)
	e12:SetCost(c82567854.cost11)
	e12:SetOperation(c82567854.op11)
	c:RegisterEffect(e12)
	--sanctuary charge (nightingale)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_IGNITION)
	e13:SetCategory(CATEGORY_ATKCHANGE)
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e13:SetRange(LOCATION_SZONE)
	e13:SetCountLimit(1)
	e13:SetTarget(c82567854.tg12)
	e13:SetOperation(c82567854.op12)
	c:RegisterEffect(e13) 
end
function c82567854.shiningfilter(c)
	return c:IsFaceup() and (c:IsCode(82567853) or c:IsCode(82567855) or c:IsCode(82568042)) 
end
function c82567854.nearlfilter(c)
	return c:IsFaceup() and c:IsCode(82567792) 
end
function c82567854.nightingalefilter(c)
	return c:IsFaceup() and (c:IsCode(82567786) or c:IsCode(82567787) or c:IsCode(82568043))  
end
function c82567854.nightingalefilter2(c)
	return c:IsFaceup() and (c:IsCode(82567786) or c:IsCode(82567787) or c:IsCode(82568043)) and c:IsAttackAbove(3000)
end
function c82567854.nightingalefilter3(c)
	return c:IsFaceup() and (c:IsCode(82567786) or c:IsCode(82567787) or c:IsCode(82568043)) and c:IsAttackBelow(2999)
end
function c82567854.protectfilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
function c82567854.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER)
end
function c82567854.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c82567854.shiningfilter,tp,LOCATION_ONFIELD,0,1,nil) and not Duel.IsExistingMatchingCard(c82567854.nearlfilter,tp,LOCATION_ONFIELD,0,1,nil) and not Duel.IsExistingMatchingCard(c82567854.nightingalefilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c82567854.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82567854.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567854.protectfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82567854,2))
	Duel.SelectTarget(tp,c82567854.protectfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c82567854.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.indoval)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
end
end
function c82567854.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x5825)==0
end
function c82567854.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c82567854.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsDestructable(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c82567854.con9(e)
	return  Duel.IsExistingMatchingCard(c82567854.shiningfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) 
end
function c82567854.con10(e)
	return  Duel.IsExistingMatchingCard(c82567854.nearlfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) 
end
function c82567854.con11(e,tp)
	return  Duel.IsExistingMatchingCard(c82567854.nightingalefilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()~=tp and aux.bpcon()
end
function c82567854.con2(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c82567854.shiningfilter,tp,LOCATION_ONFIELD,0,1,nil) and not Duel.IsExistingMatchingCard(c82567854.nearlfilter,tp,LOCATION_ONFIELD,0,1,nil) and not Duel.IsExistingMatchingCard(c82567854.nightingalefilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c82567854.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567854.protectfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82567854,2))
	Duel.SelectTarget(tp,c82567854.protectfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c82567854.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.indoval)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
end
end
function c82567854.con3(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c82567854.shiningfilter,tp,LOCATION_ONFIELD,0,1,nil) and  Duel.IsExistingMatchingCard(c82567854.nearlfilter,tp,LOCATION_ONFIELD,0,1,nil) and not Duel.IsExistingMatchingCard(c82567854.nightingalefilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c82567854.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567854.protectfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82567854,2))
	Duel.SelectTarget(tp,c82567854.protectfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c82567854.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.indoval)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
	 local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e3:SetValue(aux.tgoval)
	tc:RegisterEffect(e3)
end
end
function c82567854.con4(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c82567854.shiningfilter,tp,LOCATION_ONFIELD,0,1,nil) and not Duel.IsExistingMatchingCard(c82567854.nearlfilter,tp,LOCATION_ONFIELD,0,1,nil) and  Duel.IsExistingMatchingCard(c82567854.nightingalefilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c82567854.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567854.protectfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82567854,2))
	Duel.SelectTarget(tp,c82567854.protectfilter,tp,LOCATION_MZONE,0,1,3,nil)
end
function c82567854.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	while tc and tc:IsRelateToEffect(e) do
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.indoval)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
	tc=g:GetNext()
end
end
function c82567854.con5(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c82567854.shiningfilter,tp,LOCATION_ONFIELD,0,1,nil) and  Duel.IsExistingMatchingCard(c82567854.nearlfilter,tp,LOCATION_ONFIELD,0,1,nil) and not Duel.IsExistingMatchingCard(c82567854.nightingalefilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c82567854.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567854.protectfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82567854,2))
	Duel.SelectTarget(tp,c82567854.protectfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c82567854.op5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.indoval)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
	 local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e3:SetValue(aux.tgoval)
	tc:RegisterEffect(e3)
end
end
function c82567854.con6(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c82567854.shiningfilter,tp,LOCATION_ONFIELD,0,1,nil) and not Duel.IsExistingMatchingCard(c82567854.nearlfilter,tp,LOCATION_ONFIELD,0,1,nil) and  Duel.IsExistingMatchingCard(c82567854.nightingalefilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c82567854.tg6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567854.protectfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82567854,2))
	Duel.SelectTarget(tp,c82567854.protectfilter,tp,LOCATION_MZONE,0,1,3,nil)
end
function c82567854.op6(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	while tc and tc:IsRelateToEffect(e) do
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.indoval)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
	tc=g:GetNext()
end
end
function c82567854.con7(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c82567854.shiningfilter,tp,LOCATION_ONFIELD,0,1,nil) and  Duel.IsExistingMatchingCard(c82567854.nearlfilter,tp,LOCATION_ONFIELD,0,1,nil) and  Duel.IsExistingMatchingCard(c82567854.nightingalefilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c82567854.tg7(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567854.protectfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82567854,2))
	Duel.SelectTarget(tp,c82567854.protectfilter,tp,LOCATION_MZONE,0,1,3,nil)
end
function c82567854.op7(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	while tc and tc:IsRelateToEffect(e) do
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.indoval)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
	 local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e3:SetValue(aux.tgoval)
	tc:RegisterEffect(e3)
	tc=g:GetNext()
end
end
function c82567854.con8(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c82567854.shiningfilter,tp,LOCATION_ONFIELD,0,1,nil) and  Duel.IsExistingMatchingCard(c82567854.nearlfilter,tp,LOCATION_ONFIELD,0,1,nil) and  Duel.IsExistingMatchingCard(c82567854.nightingalefilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c82567854.tg8(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567854.protectfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82567854,2))
	Duel.SelectTarget(tp,c82567854.protectfilter,tp,LOCATION_MZONE,0,1,3,nil)
end
function c82567854.op8(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	while tc and tc:IsRelateToEffect(e) do
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.indoval)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
	 local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e3:SetValue(aux.tgoval)
	tc:RegisterEffect(e3)
	tc=g:GetNext()
end
end
function c82567854.cost11(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end 
	local ni=Duel.SelectMatchingCard(tp,c82567854.nightingalefilter2,tp,LOCATION_MZONE,0,1,1,nil)
	 local   nii=ni:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		nii:RegisterEffect(e1)
		
	end
function c82567854.tg11(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
end
function c82567854.op11(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c82567854.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,p)
end
function c82567854.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_MONSTER) or re:GetHandler():IsType(TYPE_SPELL)
end
function c82567854.tg12(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsSetCard(0x825) and chkc:IsFaceup() and c82567854.nightingalefilter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c82567854.nightingalefilter3,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82567854,3))
	Duel.SelectTarget(tp,c82567854.nightingalefilter3,tp,LOCATION_MZONE,0,1,1,nil)
end
function c82567854.op12(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)
  then  local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end