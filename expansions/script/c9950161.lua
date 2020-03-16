--天地乖离·开辟之星
function c9950161.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950161,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950161+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c9950161.cost)
	e1:SetTarget(c9950161.target)
	e1:SetOperation(c9950161.activate)
	c:RegisterEffect(e1)
end
function c9950161.cfilter(c)
	return c:IsSetCard(0x9ba5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c9950161.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950161.cfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c9950161.cfilter,1,1,REASON_COST,nil)
end
function c9950161.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
	Duel.SetChainLimit(c9950161.chlimit)
end
function c9950161.chlimit(e,ep,tp)
	return tp==ep
end
function c9950161.cfilter2(c,p)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(1-p)
end
function c9950161.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		local ct=g:FilterCount(c9950161.cfilter2,nil,tp)
		if ct>0 then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,ct,REASON_EFFECT)
		end
	end
end