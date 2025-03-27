--混沌No.90 银河眼光子领主
function c22348446.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22348446.discon)
	e1:SetCost(c22348446.discost)
	e1:SetTarget(c22348446.distg)
	e1:SetOperation(c22348446.disop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory()
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DETACH_MATERIAL)
	e2:SetTarget(c22348446.tg)
	e2:SetOperation(c22348446.op)
	c:RegisterEffect(e2)
end
aux.xyz_number[22348446]=90
function c22348446.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) or Duel.IsChainDisablable(ev)
end
function c22348446.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22348446.mtfilter(c)
	return c:IsSetCard(0x55) and c:IsCanOverlay()
end
function c22348446.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c22348446.mtfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c22348446.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c22348446.mtfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
		if re:IsActiveType(TYPE_MONSTER) then
			Duel.BreakEffect()
			Duel.NegateEffect(ev)
		end
	end
end
