--人理之基 静谧的哈桑
function c22021950.initial_effect(c)
	aux.AddCodeList(c,22021960)
	--to field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22021950,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22021950)
	e1:SetCondition(c22021950.condition)
	e1:SetTarget(c22021950.target)
	e1:SetOperation(c22021950.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e2:SetCondition(c22021950.condition2)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021950,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,22021951)
	e3:SetCost(c22021950.cost)
	e3:SetCondition(c22021950.con1)
	e3:SetTarget(c22021950.damtg)
	e3:SetOperation(c22021950.damop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e4:SetCondition(c22021950.con2)
	c:RegisterEffect(e4)
end
function c22021950.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsEnvironment(22021960,PLAYER_ALL,LOCATION_FZONE) and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())==0
end
function c22021950.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(22021960,PLAYER_ALL,LOCATION_FZONE) and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())==0
end
function c22021950.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsEnvironment(22021960,PLAYER_ALL,LOCATION_FZONE) and e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c22021950.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(22021960,PLAYER_ALL,LOCATION_FZONE) and e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c22021950.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c22021950.operation(e,tp,eg,ep,ev,re,r,rp)
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
function c22021950.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22021950,2))
end
function c22021950.damfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function c22021950.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22021950.damfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	local ct=Duel.GetMatchingGroupCount(c22021950.damfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*600)
end
function c22021950.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c22021950.damfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SelectOption(tp,aux.Stringid(22021950,3))
	Duel.SelectOption(tp,aux.Stringid(22021950,4))
	Duel.Damage(p,ct*600,REASON_EFFECT)
end