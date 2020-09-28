--飞翔吧，吾之金色羽翼
function c9950356.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9950356.condition)
	e1:SetTarget(c9950356.target)
	e1:SetOperation(c9950356.activate)
	c:RegisterEffect(e1)
end
function c9950356.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5)
end
function c9950356.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9950356.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9950356.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c9950356.setfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_EQUIP) and c:IsSSetable()
end
function c9950356.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if sg and Duel.Destroy(sg,REASON_EFFECT)>0 then
		local g2=Duel.GetMatchingGroup(c9950356.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if g2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(9950356,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local tc=g2:Select(tp,1,1,nil)
			Duel.SSet(tp,tc)
		end
	end
end

