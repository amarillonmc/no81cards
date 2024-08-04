local m=15005455
local cm=_G["c"..m]
cm.name="不安的种子"
function cm.initial_effect(c)
	--negate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.atcon)
	e0:SetTarget(cm.attg)
	e0:SetOperation(cm.atop)
	c:RegisterEffect(e0)
	--get effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_XMATERIAL)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(cm.gfcon)
	c:RegisterEffect(e1)
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_XMATERIAL)
	--e2:SetCode(EFFECT_DISABLE_EFFECT)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetValue(RESET_TURN_SET)
	--e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e2:SetCondition(cm.gfcon)
	--c:RegisterEffect(e2)
end
function cm.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOnField() and c:IsCanOverlay()
end
function cm.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=re:GetHandler()
	if chk==0 then return at:IsType(TYPE_XYZ) and at:IsOnField() end
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=re:GetHandler()
	if c:IsRelateToEffect(e) and at:IsType(TYPE_XYZ) and at:IsOnField() and c:IsCanOverlay() and not at:IsImmuneToEffect(e) then
		Duel.Overlay(at,Group.FromCards(c))
	end
end
function cm.gfcon(e)
	return e:GetHandler():IsType(TYPE_XYZ)
end