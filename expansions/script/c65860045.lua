--浮华若梦·绮梦挥光
function c65860045.initial_effect(c)
	--超量
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	--炸卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65860045,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,65860045)
	e3:SetCondition(c65860045.descon)
	e3:SetCost(c65860045.descost)
	e3:SetTarget(c65860045.destg)
	e3:SetOperation(c65860045.desop)
	c:RegisterEffect(e3)
end

function c65860045.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xa36)
end
function c65860045.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if #g>0 then
	Duel.Destroy(g,REASON_COST)
	end
end
function c65860045.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) end
end
function c65860045.spfilter(c,e,tp)
	return (not c:IsSetCard(0xa36) or c:IsFacedown()) and c:IsAbleToDeck()
end
function c65860045.desop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local g=Duel.GetMatchingGroup(c65860045.spfilter,tp,LOCATION_ONFIELD,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		end
	end
end