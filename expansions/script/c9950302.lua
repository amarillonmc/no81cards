--伊莉雅·友情羁绊
function c9950302.initial_effect(c)
	aux.AddCodeList(c,9951285,9951293)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9950302.condition)
	e1:SetTarget(c9950302.target)
	e1:SetOperation(c9950302.activate)
	c:RegisterEffect(e1)
end
function c9950302.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c9950302.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9950302.cfilter,tp,LOCATION_MZONE,0,1,nil,9951285)
		and Duel.IsExistingMatchingCard(c9950302.cfilter,tp,LOCATION_MZONE,0,1,nil,9951293)
end
function c9950302.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c9950302.chlimit)
	end
end
function c9950302.chlimit(e,ep,tp)
	return tp==ep
end
function c9950302.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end

