--机械加工·傀
local m=40010548
local cm=_G["c"..m]
cm.named_with_Machining=1
function cm.Machining(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Machining
end
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsFaceup() and cm.Machining(c)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and ep==1-tp and re:GetActivateLocation()==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil)
		if g:GetCount()>0 and rc:IsType(TYPE_MONSTER) and rc:IsLocation(LOCATION_GRAVE) and aux.NecroValleyFilter()(rc)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and rc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.BreakEffect()
			Duel.SpecialSummonStep(rc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(RESET_TURN_SET)
			rc:RegisterEffect(e2)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_SETCODE)
			e4:SetValue(cm.vfilter)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			rc:RegisterEffect(e4)
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.vfilter(e,c)
	return cm.Machining(c)
end
