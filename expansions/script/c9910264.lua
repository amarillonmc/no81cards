--幽鬼舞步
function c9910264.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9910264.condition)
	e1:SetTarget(c9910264.target)
	e1:SetOperation(c9910264.activate)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c9910264.chcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910264.chtg)
	e2:SetOperation(c9910264.chop)
	c:RegisterEffect(e2)
end
function c9910264.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9910264.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,1,nil,0x956,1)
		local b2=Duel.GetCounter(tp,1,0,0x956)>=6 and aux.nbcon(tp,re)
		local b3=Duel.GetCounter(tp,1,0,0x956)<6
		return b1 or b2 or b3
	end
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x956,1)
	if #g>0 then Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,#g,0,0) end
end
function c9910264.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chk
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x956,1)
	if #g>0 then
		for tc in aux.Next(g) do
			if tc:IsCanAddCounter(0x956,1) then
				tc:AddCounter(0x956,1)
			end
		end
		chk=true
	end
	if Duel.GetCounter(tp,1,0,0x956)>=6 then
		if Duel.IsChainNegatable(ev) then
			if chk then Duel.BreakEffect() end
			if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
			end
		end
	else
		if c:IsRelateToEffect(e) and c:IsSSetable(true) then
			if chk then Duel.BreakEffect() end
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
function c9910264.chcon(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or (re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c9910264.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_FZONE,LOCATION_FZONE)>0 end
end
function c9910264.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c9910264.repop)
end
function c9910264.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
