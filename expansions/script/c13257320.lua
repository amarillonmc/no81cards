--超时空武装 装甲-过载场
local m=13257320
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(cm.eqlimit)
	c:RegisterEffect(e11)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCondition(cm.tgcon)
	e5:SetOperation(cm.tgop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(cm.efilter1)
	c:RegisterEffect(e6)
	
end
function cm.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x5352)
end
function cm.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetOwnerPlayer()
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and Duel.GetCurrentPhase()==PHASE_END 
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function cm.efilter1(e,te)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and te:GetHandler()==ec
end
