--星逸彩
function c72100053.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,72100053+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c72100053.cost)
	e1:SetTarget(c72100053.target)
	e1:SetOperation(c72100053.activate)
	c:RegisterEffect(e1)
end
function c72100053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c72100053.tfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c72100053.tgfilter,tp,LOCATION_DECK,0,1,c,tp,c:GetAttack())
end
function c72100053.tgfilter(c,tp,atk)
	return c:IsAttackBelow(atk) and c:IsAbleToGrave() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(c72100053.tgfilter1,tp,LOCATION_DECK,0,1,c,atk-c:GetAttack(),c:GetAttribute())
end
function c72100053.tgfilter1(c,atk,att)
	return c:IsAttackBelow(atk) and c:IsAbleToGrave() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and not c:IsAttribute(att)
end
function c72100053.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c72100053.desfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c72100053.tfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c72100053.tfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c72100053.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c72100053.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tp,atk)
		local gc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c72100053.tgfilter1,tp,LOCATION_DECK,0,1,1,gc,atk-gc:GetAttack(),gc:GetAttribute())
		g:Merge(g1)
		if g:GetCount()>1 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

