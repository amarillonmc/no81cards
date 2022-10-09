--人理之基 百貌的哈桑
function c22021940.initial_effect(c)
	aux.AddCodeList(c,22021960)
	--to field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22021940,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22021940)
	e1:SetCondition(c22021940.condition)
	e1:SetTarget(c22021940.target)
	e1:SetOperation(c22021940.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e2:SetCondition(c22021940.condition2)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021940,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,22021941)
	e3:SetCondition(c22021940.con1)
	e3:SetCost(c22021940.cost)
	e3:SetTarget(c22021940.sptg)
	e3:SetOperation(c22021940.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e4:SetCondition(c22021940.con2)
	c:RegisterEffect(e4)
end
function c22021940.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsEnvironment(22021960,PLAYER_ALL,LOCATION_FZONE) and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())==0
end
function c22021940.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(22021960,PLAYER_ALL,LOCATION_FZONE) and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())==0
end
function c22021940.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsEnvironment(22021960,PLAYER_ALL,LOCATION_FZONE) and e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c22021940.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(22021960,PLAYER_ALL,LOCATION_FZONE) and e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c22021940.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c22021940.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function c22021940.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22021940,2))
end
function c22021940.filter(c,e,tp)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function c22021940.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and c22021940.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22021940.filter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22021940.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22021940.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SelectOption(tp,aux.Stringid(22021940,3))
		Duel.SelectOption(tp,aux.Stringid(22021940,4))
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end