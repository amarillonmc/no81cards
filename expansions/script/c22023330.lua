--绝技：八岐怒涛
function c22023330.initial_effect(c)
	aux.AddCodeList(c,22023320,22023310)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22023330.actcon)
	e1:SetTarget(c22023330.target)
	e1:SetOperation(c22023330.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c22023330.actcon2)
	e2:SetCost(c22023330.descost)
	e2:SetTarget(c22023330.target)
	e2:SetOperation(c22023330.activate)
	c:RegisterEffect(e2)
end
function c22023330.cfilter(c)
	return c:IsFaceup() and c:IsCode(22023320)
end
function c22023330.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023330.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22023330.actcon2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c22023330.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22023330.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,8,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,8,8,REASON_COST)
end
function c22023330.filter(c)
	return c:IsFaceup() and c:IsCode(22023310)
end
function c22023330.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SelectOption(tp,aux.Stringid(22023330,2))
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c22023330.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,8,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SelectOption(tp,aux.Stringid(22023330,3))
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT) and Duel.IsExistingMatchingCard(c22023330.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22023330,1)) then
			Duel.SelectOption(tp,aux.Stringid(22023330,4))
			Duel.Damage(1-tp,400,REASON_EFFECT)
			Duel.Damage(1-tp,400,REASON_EFFECT)
			Duel.Damage(1-tp,400,REASON_EFFECT)
			Duel.Damage(1-tp,400,REASON_EFFECT)
			Duel.Damage(1-tp,400,REASON_EFFECT)
			Duel.Damage(1-tp,400,REASON_EFFECT)
			Duel.Damage(1-tp,400,REASON_EFFECT)
			Duel.Damage(1-tp,400,REASON_EFFECT)
		end
	end
end