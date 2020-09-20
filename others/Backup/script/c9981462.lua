--15年的轨迹
function c9981462.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9981462+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9981462.condition)
	e1:SetTarget(c9981462.target)
	e1:SetOperation(c9981462.activate)
	c:RegisterEffect(e1)
end
function c9981462.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c9981462.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9981462.cfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end
function c9981462.filter(c)
	return c9981462.cfilter(c) and c:IsAbleToHand()
end
function c9981462.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981462.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c9981462.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c9981462.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c9981462.filter,tp,LOCATION_GRAVE,0,nil)
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)>0 then
		local ct=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if ct>0 and Duel.IsPlayerCanDraw(tp,ct)
			and Duel.SelectYesNo(tp,aux.Stringid(9981462,0)) then
			Duel.BreakEffect()
			Duel.Draw(tp,ct,REASON_EFFECT)
		end
	end
end

