--人理之诗 三千世界
function c22020660.initial_effect(c)
	aux.AddCodeList(c,22020631)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,22020660+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22020660.cost)
	e1:SetCondition(c22020660.condition)
	e1:SetTarget(c22020660.target)
	e1:SetOperation(c22020660.activate)
	c:RegisterEffect(e1)
end
function c22020660.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Debug.Message("别无他法！")
end
function c22020660.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020631)
end
function c22020660.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c22020660.cfilter,tp,LOCATION_ONFIELD,0,nil)
	return ct>0 and aux.dscon()
end
function c22020660.desfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(3000)
end
function c22020660.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c22020660.cfilter,tp,LOCATION_ONFIELD,0,nil)
		if ct<=1 then return Duel.IsExistingMatchingCard(c22020660.cfilter,tp,LOCATION_MZONE,0,1,nil) end
		return true
	end
end
function c22020660.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22020660.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetCount()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(3000)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	if ct>=1 then
		Debug.Message("曝尸与三千世界之中吧......")
	end
	if ct>=2 then
		local dg=Duel.GetMatchingGroup(c22020660.desfilter,tp,0,LOCATION_MZONE,nil)
		if dg:GetCount()>0 then
			Duel.SendtoGrave(dg,REASON_EFFECT)
			Debug.Message("天魔轰临！")
		end
	end
	if ct>=3 then
		Duel.Damage(1-tp,3000,REASON_EFFECT)
		Debug.Message("这正是魔王的三段击！")
	end
end