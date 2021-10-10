--方舟骑士·庇护者圣域 夜莺
function c82567786.initial_effect(c)
	c:EnableReviveLimit()
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567786,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c82567786.adcost)
	e2:SetCountLimit(1,82567786)
	e2:SetTarget(c82567786.target)
	e2:SetOperation(c82567786.activate)
	e2:SetValue(c82567786.rdval)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82567786,2))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,82567775)
	e3:SetTarget(c82567786.cttg)
	e3:SetOperation(c82567786.ctop)
	c:RegisterEffect(e3)
	--Cage Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567786,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,82567875)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_MAIN_END+TIMING_SUMMON+TIMING_SPSUMMON+TIMINGS_CHECK_MONSTER)
	e4:SetCondition(c82567786.spcon)
	e4:SetTarget(c82567786.sptg)
	e4:SetCost(c82567786.spcost)
	e4:SetOperation(c82567786.spop)
	c:RegisterEffect(e4)
	--sanctuary
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	e5:SetValue(c82567786.efilter)
	e5:SetCondition(c82567786.iefcon)
	c:RegisterEffect(e5)
	--cage release
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(82567786,4))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c82567786.acttg)
	e6:SetOperation(c82567786.actop)
	c:RegisterEffect(e6)
end
function c82567786.cagefilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsCode(82567788)
end
function c82567786.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.CheckReleaseGroup(tp,c82567786.cagefilter,1,nil)  end
end
function c82567786.actop(e,tp,eg,ep,ev,re,r,rp)
	if not  Duel.CheckReleaseGroup(tp,c82567786.cagefilter,1,nil) then return false end 
	local g1=Duel.SelectReleaseGroup(tp,c82567786.cagefilter,1,1,nil)
	Duel.Release(g1,REASON_COST)
end
function c82567786.filter(c)
	return c:IsFaceup() and not c:IsCode(82567786) and not c:IsCode(82567787)  and not c:IsCode(82568087) and not c:IsCode(82568086)
end
function c82567786.rdval(e)
	return e:GetHandler():GetAttack()/2
end
function c82567786.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
end
function c82567786.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c82567786.filter,tp,LOCATION_MZONE,0,nil)
	local nsg=sg:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c82567786.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,nsg,tp,0)
end
function c82567786.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82567786.filter,tp,LOCATION_MZONE,0,nil)
	local atk=c82567786.rdval(e)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	if not c:IsRelateToEffect(e) then return false end
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c82567786.ctfilter(c)
	return c:IsFaceup() 
end
function c82567786.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x5825,2) and not chkc==c:GetHandler() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567786.ctfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),0x5825,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82567786.ctfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),0x5825,2)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5825,2)
end
function c82567786.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and aux.bpcon()
end
function c82567786.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp)
  then  tc:AddCounter(0x5825,2)
	end
end
function c82567786.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAttackAbove(600) end 
	if c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-600)
		c:RegisterEffect(e1)
		end
	end
function c82567786.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82567788,0,0x4011,0,0,2,RACE_FIEND,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c82567786.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,82567788,0,0x4011,0,0,2,RACE_FIEND,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,82567788)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c82567786.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner() and  te:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER)
end
function c82567786.iefcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,82567788) 
end

