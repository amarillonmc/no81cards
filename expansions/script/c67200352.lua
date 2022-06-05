--迷路的使魔 莉莉
function c67200352.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c67200352.descon)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200352,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c67200352.thcon)
	e3:SetCost(c67200352.thcost)
	e3:SetTarget(c67200352.thtg)
	e3:SetOperation(c67200352.thop)
	c:RegisterEffect(e3)
end
function c67200352.descon(e)
	return not Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),0x671)
end
--
function c67200352.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function c67200352.costfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost() and c:IsSetCard(0x671) and c:IsFaceup()
end
function c67200352.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200352.costfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67200352.costfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c67200352.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c67200352.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
