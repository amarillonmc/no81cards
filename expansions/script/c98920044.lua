--铠装合体 阿修罗霍普雷
function c98920044.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920044,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c98920044.eqcost)
	e3:SetTarget(c98920044.mttg)
	e3:SetOperation(c98920044.mtop)
	c:RegisterEffect(e3)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98920044,1))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c98920044.negcon)
	e5:SetTarget(c98920044.negtg)
	e5:SetOperation(c98920044.negop)
	c:RegisterEffect(e5)
end
aux.xyz_number[98950044]=39
aux.xyz_number[56840427]=39
function c98920044.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920044.mtfilter(c)
	return c:IsSetCard(0x107e) and c:IsCanOverlay()
end
function c98920044.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c98920044.mtfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c98920044.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c98920044.mtfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c98920044.eqfilter(c,tp)
	return c:IsSetCard(0x107e) and c.zw_equip_monster and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function c98920044.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c98920044.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and g:IsExists(c98920044.eqfilter,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98920044.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=g:FilterSelect(tp,c98920044.eqfilter,1,1,nil,tp):GetFirst()
		if not tc then return end
		tc.zw_equip_monster(tc,tp,c)
	end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end