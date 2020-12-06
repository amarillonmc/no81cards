--桃绯术式 日轮之锁
function c9910525.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9910525+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910525.condition)
	e1:SetTarget(c9910525.target)
	e1:SetOperation(c9910525.activate)
	c:RegisterEffect(e1)
end
function c9910525.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_MONSTER)
end
function c9910525.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>c:GetBaseAttack()
end
function c9910525.atkfilter2(c,e)
	return c:IsFaceup() and c:GetAttack()>c:GetBaseAttack() and not c:IsImmuneToEffect(e)
		and not c:IsHasEffect(EFFECT_REVERSE_UPDATE)
end
function c9910525.atkdiff(c)
	return math.abs(c:GetBaseAttack()-c:GetAttack())
end
function c9910525.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tc=re:GetHandler()
		if not tc:IsLevelAbove(1) then return false end
		local lv=tc:GetLevel()
		local atkg=Duel.GetMatchingGroup(c9910525.atkfilter,tp,LOCATION_MZONE,0,nil)
		return atkg:CheckWithSumGreater(c9910525.atkdiff,lv*100,1,99)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9910525.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsLevelAbove(1) then return false end
	local lv=tc:GetLevel()
	local atkg=Duel.GetMatchingGroup(c9910525.atkfilter2,tp,LOCATION_MZONE,0,nil,e)
	if not atkg:CheckWithSumGreater(c9910525.atkdiff,lv*100,1,99) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local atkg2=atkg:SelectWithSumGreater(tp,c9910525.atkdiff,lv*100,1,99,nil)
	if atkg2:GetCount()==0 then return end
	local ct=0
	local sc=atkg2:GetFirst()
	while sc do
		local diff=math.abs(sc:GetBaseAttack()-sc:GetAttack())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-diff)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		if sc:IsType(TYPE_RITUAL) then ct=ct+1 end
		sc=atkg2:GetNext()
	end
	if Duel.NegateEffect(ev) and ct>0 and Duel.IsPlayerCanDraw(tp,ct)
		and Duel.SelectYesNo(tp,aux.Stringid(9910525,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
