--溢水涡流之沧泉枢
function c88888284.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88888284+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c88888284.condition)
	e1:SetTarget(c88888284.target)
	e1:SetOperation(c88888284.operation)
	c:RegisterEffect(e1)
end
function c88888284.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function c88888284.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c88888284.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c88888284.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local t1=Duel.IsPlayerCanSpecialSummonMonster(tp,88888285,0x8910,TYPES_TOKEN_MONSTER,0,0,4,RACE_AQUA,ATTRIBUTE_DARK)
	local t2=Duel.IsPlayerCanSpecialSummonMonster(tp,88888285,0x8910,TYPES_TOKEN_MONSTER,0,0,6,RACE_AQUA,ATTRIBUTE_DARK)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		(t1 or t2) end
	local lv=0
	if t1 and t2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(88888284,2))
		e:SetLabel(Duel.AnnounceLevel(tp,4,6,5))
	elseif t1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(88888284,2))
		e:SetLabel(Duel.AnnounceLevel(tp,4,4))
	elseif t2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(88888284,2))
		e:SetLabel(Duel.AnnounceLevel(tp,6,6))
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c88888284.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,88888285,0x8910,TYPES_TOKEN_MONSTER,0,0,lv,RACE_AQUA,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,88888285)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetValue(lv)
	token:RegisterEffect(e1,true)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_TUNER)
		e2:SetValue(c88888284.tnval)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetAbsoluteRange(tp,1,0)
		e3:SetCondition(c88888284.splimitcon)
		e3:SetTarget(c88888284.splimit)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CONTROL)
		token:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end
function c88888284.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c88888284.splimitcon(e)
	return e:GetHandler():IsControler(e:GetOwnerPlayer())
end
function c88888284.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER) and c:IsLocation(LOCATION_EXTRA)
end