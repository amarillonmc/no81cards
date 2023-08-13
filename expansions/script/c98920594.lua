--抒情歌鸲-欢悦音乐鸫
function c98920594.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,1,2,nil,nil,99)
	--ATK Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c98920594.atkval)
	c:RegisterEffect(e1)
	--negate activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920594,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c98920594.negcon)
	e2:SetCost(c98920594.negcost)
	e2:SetTarget(c98920594.negtg)
	e2:SetOperation(c98920594.negop)
	c:RegisterEffect(e2)
	 --material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920594,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c98920594.cost)
	e4:SetTarget(c98920594.mttg)
	e4:SetOperation(c98920594.mtop)
	c:RegisterEffect(e4)
end
function c98920594.atkval(e,c)
	return c:GetOverlayCount()*500
end
function c98920594.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920594.mtfilter(c,e)
	return c:IsRace(RACE_WINDBEAST) and c:IsCanOverlay()
end
function c98920594.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c98920594.mtfilter,tp,LOCATION_DECK,0,2,nil) end
end
function c98920594.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c98920594.mtfilter,tp,LOCATION_DECK,0,2,2,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c98920594.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
		and re:IsActiveType(TYPE_TRAP+TYPE_SPELL) and Duel.IsChainDisablable(ev) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xf7)
end
function c98920594.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920594.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,re:GetHandler(),1,0,0)
end
function c98920594.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end