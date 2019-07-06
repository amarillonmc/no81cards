--Heavenly Maid : Feast Preparation
function c33700205.initial_effect(c)
	--Send 1 "Heavenly Maid" monster you control to the GY, if you do, Draw 2 cards, then return 1 card in your hand to the top or the bottom of your deck. You can only activate 1 "Heavenly Maid : Feast Preparation" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33700205)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetTarget(c33700205.tg)
	e1:SetOperation(c33700205.op)
	c:RegisterEffect(e1)
end
function c33700205.filter(c)
	return c:IsSetCard(0x444) and c:IsAbleToGrave()
end
function c33700205.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700205.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,2) end
	local g1=Duel.GetMatchingGroup(c33700205.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c33700205.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33700205.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g)
	if g:GetCount()==0 or Duel.SendtoGrave(g,REASON_EFFECT)==0 or not g:GetFirst():IsLocation(LOCATION_GRAVE) or Duel.Draw(tp,2,REASON_EFFECT)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		local p=Duel.SelectOption(tp,aux.Stringid(33700205,0),aux.Stringid(33700205,1))
		Duel.SendtoDeck(g,nil,p,REASON_EFFECT)
	end
end
