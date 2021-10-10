--冰魔法使 椎名沙夜音
function c67200091.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,67200084,aux.FilterBoolFunction(Card.IsFusionSetCard,0x673),1,true,true)	 
	--fusion success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200091,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,67200091)
	e1:SetCondition(c67200091.thcon)
	e1:SetTarget(c67200091.thtg)
	e1:SetOperation(c67200091.thop)
	c:RegisterEffect(e1) 
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200091,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,67200092)
	e3:SetCost(c67200091.discost)
	e3:SetTarget(c67200091.distg)
	e3:SetOperation(c67200091.disop)
	c:RegisterEffect(e3)
end
--
function c67200091.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c67200091.thfilter(c)
	return c:IsCode(67200084) and c:IsAbleToHand()
end
function c67200091.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200091.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c67200091.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200091.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
--
function c67200091.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c67200091.fdfilter(c,i)
	return c:IsFacedown() and c:GetSequence()==i
end
function c67200091.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local fdzone=0
	for i=0,4 do
		if Duel.IsExistingMatchingCard(c67200091.fdfilter,tp,0,LOCATION_MZONE,1,nil,i) then
			fdzone=fdzone|1<<i
		end
	end
	if chk==0 then return ~fdzone&0x1f>0 end
	local dis=Duel.SelectField(tp,1,0,LOCATION_MZONE,(fdzone|0x60)<<16)
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function c67200091.disfilter2(c,dis)
	return c:IsFaceup() and (2^c:GetSequence())*0x10000&dis~=0
end
function c67200091.disfilter3(c,dis)
	return c:IsFacedown() and (2^c:GetSequence())*0x10000&dis~=0
end
function c67200091.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dis=e:GetLabel()
	local g=Duel.GetMatchingGroup(c67200091.disfilter2,tp,0,LOCATION_MZONE,nil,dis)
	local tc=g:GetFirst()
	while tc do
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CANNOT_ATTACK)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		dis=dis-(2^tc:GetSequence())*0x10000
		tc=g:GetNext()
	end
	local sg=Duel.GetMatchingGroup(c67200091.disfilter3,tp,0,LOCATION_MZONE,nil,dis)
	local sc=sg:GetFirst()
	while sc do
		dis=dis-(2^sc:GetSequence())*0x10000
		sc=sg:GetNext()
	end
	if dis~=0 then
		if tp==1 then
			dis=((dis&0xffff)<<16)|((dis>>16)&0xffff)
		end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_FIELD)
		e3:SetValue(dis)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
