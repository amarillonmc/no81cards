--无悔守护 究极骑士斯雷普兽
function c16349015.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c16349015.matfilter1,nil,nil,aux.NonTuner(nil),2,99)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16349015,1))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c16349015.target)
	e1:SetOperation(c16349015.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c16349015.ndop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,16349015)
	e3:SetCondition(c16349015.mvcon)
	e3:SetTarget(c16349015.mvtg)
	e3:SetOperation(c16349015.mvop)
	c:RegisterEffect(e3)
end
function c16349015.matfilter1(c,syncard)
	return c:IsRace(RACE_BEAST+RACE_WARRIOR+RACE_BEASTWARRIOR) and (c:IsTuner(syncard) or c:IsLevelBelow(3))
end
function c16349015.pfilter(c,tp)
	return c:IsCode(16349063) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c16349015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16349015.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c16349015.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16349015.pfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function c16349015.ndop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(1)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
end
function c16349015.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c16349015.filter(c)
	local seq=c:GetSequence()
	local tp=c:GetControler()
	if c:IsLocation(LOCATION_SZONE) then
		return (seq>0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_SZONE,seq+1))
	elseif c:IsLocation(LOCATION_MZONE) then
		return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
			or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
			or (seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1))
			or (seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3))
	end
end
function c16349015.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c16349015.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16349015.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16349015,0))
	Duel.SelectTarget(tp,c16349015.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c16349015.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local seq=tc:GetSequence()
	local flag=0
	if tc:IsLocation(LOCATION_MZONE) then
		if seq>0 and seq<5 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
		if seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1) then flag=flag|(1<<1) end
		if seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3) then flag=flag|(1<<3) end
		if flag==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~flag)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c16349015.efilter)
		tc:RegisterEffect(e1)
	end
	if tc:IsLocation(LOCATION_SZONE) then
		if seq>0 and seq<5 and Duel.CheckLocation(tp,LOCATION_SZONE,seq-1) then flag=flag|(1<<(seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_SZONE,seq+1) then flag=flag|(1<<(seq+1)) end
		if flag==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,~(flag<<8))
		local nseq=math.log(s>>8,2)
		Duel.MoveSequence(tc,nseq)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c16349015.efilter)
		tc:RegisterEffect(e1)
	end
end
function c16349015.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x3dc2)
end