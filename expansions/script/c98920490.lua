--暗星之机忆 伽拉忒亚
function c98920490.initial_effect(c)
	c:SetSPSummonOnce(98920490)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2,c98920490.ovfilter,aux.Stringid(98920490,0))
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c98920490.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
--negative
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920490,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_TODECK)
	e2:SetCode(EVENT_CHAINING)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c98920490.cost)
	e2:SetCondition(c98920490.discon)
	e2:SetTarget(c98920490.distg)
	e2:SetOperation(c98920490.disop)
	c:RegisterEffect(e2)
end
function c98920490.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920490.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x11b) and c:IsType(TYPE_LINK)
end
function c98920490.indcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c98920490.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)
end
function c98920490.tdfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c98920490.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c98920490.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c98920490.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local rc=re:GetHandler()
	if tc and tc:IsRelateToEffect(e) and Duel.NegateEffect(ev) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end