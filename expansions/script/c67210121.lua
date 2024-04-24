--夏乡净梦 绘灵之笔
function c67210121.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c67210121.target)
	e1:SetOperation(c67210121.activate)
	c:RegisterEffect(e1)
	--pendulum effect apply
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67210121,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,67210121)
	e2:SetCondition(c67210121.chcon)
	e2:SetTarget(c67210121.chtg)
	e2:SetOperation(c67210121.chop)
	c:RegisterEffect(e2)	
end
function c67210121.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,67210121,0,TYPES_EFFECT_TRAP_MONSTER,1900,700,5,RACE_PSYCHO,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67210121.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,67210121,0,TYPES_EFFECT_TRAP_MONSTER,1900,700,5,RACE_PSYCHO,ATTRIBUTE_WATER) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end
--
function c67210121.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c67210121.pcfilter(c)
	return c:IsCode(67210119) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c67210121.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c67210121.pcfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil) end
end
function c67210121.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67210121.pcfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67210121,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_TOEXTRA)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCountLimit(1)
		e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		e2:SetTarget(c67210121.destg)
		e2:SetOperation(c67210121.desop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
--
function c67210121.filter22(c)
	return c:IsSetCard(0x567e) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c67210121.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c67210121.filter22,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c67210121.filter(c)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)==TYPE_PENDULUM
end
function c67210121.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67210121.filter22),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67210112,0))
		local gg=Duel.SelectMatchingCard(tp,c67210112.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if gg:GetCount()>0 then
			Duel.SendtoExtraP(gg,nil,REASON_EFFECT)
		end
	end
end

