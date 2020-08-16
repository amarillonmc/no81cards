--狮子王的邀请
function c9951606.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9951606.target)
	e1:SetOperation(c9951606.activate)
	c:RegisterEffect(e1)
end
function c9951606.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3ba6) and c:IsLevelBelow(4) and c:IsAbleToGrave()
end
function c9951606.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local draw=Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x46)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951606.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and (not draw or Duel.IsPlayerCanDraw(tp,1)) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	if draw then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c9951606.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9951606.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE)
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x46) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

