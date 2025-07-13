--人理之诗 怪物的黄金剑
function c22023740.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,22023740+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22023740.negcon)
	e1:SetCost(c22023740.negcost)
	e1:SetTarget(c22023740.negtg)
	e1:SetOperation(c22023740.negop)
	c:RegisterEffect(e1)
end
function c22023740.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c22023740.cfilter(c)
	return c:IsFacedown() and c:IsAbleToGraveAsCost()
end
function c22023740.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22023740.cfilter,tp,LOCATION_ONFIELD,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22023740.cfilter,tp,LOCATION_ONFIELD,0,1,1,c,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22023740.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SelectOption(tp,aux.Stringid(22023740,3))
	Duel.SelectOption(tp,aux.Stringid(22023740,4))
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	if bit.band(re:GetHandler():GetOriginalType(),TYPE_MONSTER)~=0 then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	else
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	end
end
function c22023740.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if rc:IsRelateToEffect(re) and Duel.SelectOption(tp,aux.Stringid(22023740,5)) and Duel.Destroy(eg,REASON_EFFECT)~=0
		and not (rc:IsLocation(LOCATION_HAND+LOCATION_DECK) or rc:IsLocation(LOCATION_REMOVED) and rc:IsFacedown())
		and aux.NecroValleyFilter()(rc) then
		if rc:IsType(TYPE_MONSTER) and (not rc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
				or rc:IsLocation(LOCATION_EXTRA) and rc:IsFaceup() and Duel.GetLocationCountFromEx(tp,1-tp,nil,rc)>0)
			and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)
			and Duel.SelectYesNo(tp,aux.Stringid(22023740,1)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(rc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(tp,rc)
		elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0)
			and rc:IsSSetable(true) and Duel.SelectYesNo(tp,aux.Stringid(22023740,2)) then
			Duel.BreakEffect()
			Duel.SSet(tp,rc,1-tp)
		end
	end
end