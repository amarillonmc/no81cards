--方舟骑士·庇护者挽歌 夜莺
function c82567787.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,c82567787.ovfilter,aux.Stringid(82567787,4),nil,c82567787.xyzop)
	c:EnableReviveLimit()
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567787,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c82567787.adcost)
	e2:SetCountLimit(1,82567787)
	e2:SetTarget(c82567787.target)
	e2:SetOperation(c82567787.activate)
	e2:SetValue(c82567787.rdval)
	c:RegisterEffect(e2)
	--Cage Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567787,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCountLimit(2,82567777+EFFECT_COUNT_CODE_DUEL)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(TIMING_BATTLE_START+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_MAIN_END+TIMING_SUMMON+TIMING_SPSUMMON+TIMINGS_CHECK_MONSTER,TIMING_BATTLE_START+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_MAIN_END+TIMING_SUMMON+TIMING_SPSUMMON+TIMINGS_CHECK_MONSTER)
	e4:SetTarget(c82567787.sptg)
	e4:SetCost(c82567787.spcost)
	e4:SetOperation(c82567787.spop)
	c:RegisterEffect(e4)
	--sanctuary
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	e5:SetValue(c82567787.efilter)
	e5:SetCondition(c82567787.iefcon)
	c:RegisterEffect(e5)
	--code
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_CHANGE_CODE)
	e6:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e6:SetValue(82567786)
	c:RegisterEffect(e6)
   if not c82567787.global_check then
		c82567787.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c82567787.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c82567787.checkop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then return
		Duel.RegisterFlagEffect(ep,82567787,RESET_PHASE+PHASE_END,0,1)
	end
end
function c82567787.ovfilter(c,tp)
	return c:IsFaceup() and ((c:IsType(TYPE_XYZ) and c:IsRank(4) and c:IsSetCard(0x825)) or (c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER))) 
end
function c82567787.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,82567787)~=0  end
	
end
function c82567787.filter(c)
	return c:IsFaceup() and not c:IsCode(82567786) and not c:IsCode(82567787)  
end
function c82567787.rdval(e)
	return e:GetHandler():GetAttack()/2
end
function c82567787.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
end
function c82567787.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c82567787.filter,tp,LOCATION_MZONE,0,nil)
	local nsg=sg:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c82567787.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,nsg,tp,0)
end
function c82567787.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82567787.filter,tp,LOCATION_MZONE,0,nil)
	local atk=c82567787.rdval(e)
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
function c82567787.ctfilter(c)
	return c:IsFaceup() 
end
function c82567787.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x5825,2) and not chkc==c:GetHandler() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567787.ctfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),0x5825,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82567787.ctfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),0x5825,2)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5825,2)
end
function c82567787.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp)
  then  tc:AddCounter(0x5825,2)
	end
end
function c82567787.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82567787.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82567815,0,0x4011,0,0,2,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c82567787.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,82567815,0,0x4011,0,0,2,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,82567815)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c82567787.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_MONSTER)
end
function c82567787.iefcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,82567788) or
		 Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,82567815)
end

