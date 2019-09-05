--深界生物 龙鬃螺鸠
local m=33330009
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz Summon
	aux.AddXyzProcedure(c,nil,6,2)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.ngcon)
	e1:SetCost(cm.ngcost)
	e1:SetTarget(cm.ngtg)
	e1:SetOperation(cm.ngop)
	c:RegisterEffect(e1)  
	--Destroy Replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.reptg)
	c:RegisterEffect(e2)  
end
--Negate
function cm.ngcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsChainDisablable(ev) and re:GetHandler():IsAbleToChangeControler()
		and not re:GetHandler():IsType(TYPE_TOKEN)
end
function cm.ngcost(e,tp,eg,ep,ev,re,r,rp,chk)
	--local og=e:GetHandler():GetOverlayGroup()
   -- if chk==0 then return og:GetCount()>0 and og:IsExists(Card.IsSetCard,1,nil,0x556) end
   -- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
   -- local g=og:FilterSelect(tp,Card.IsSetCard,1,1,nil,0x556)
   -- Duel.SendtoGrave(g,REASON_COST)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.ngop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and not rc:IsType(TYPE_TOKEN) and c:IsType(TYPE_XYZ) and c:IsRelateToEffect(e) and c:IsFaceup() then
		local og=rc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(rc))
	end
end
--Destroy Replace
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT)
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end