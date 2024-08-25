--数码兽的心路
function c50221230.initial_effect(c)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c50221230.condition)
	e2:SetTarget(c50221230.target)
	e2:SetOperation(c50221230.operation)
	c:RegisterEffect(e2)
end
function c50221230.filter(c,e,tp,ec)
	return c:IsSetCard(0xcb1) and c:IsLevel(9) and c:IsAttribute(ec) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c50221230.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c50221230.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=re:GetHandler()
	local at=ec:GetAttribute()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50221230.filter,tp,LOCATION_DECK,0,1,nil,e,tp,at) end	
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c50221230.operation(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	local at=ec:GetAttribute()
	if Duel.NegateActivation(ev) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c50221230.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,at)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end