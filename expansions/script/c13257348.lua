--超时空武装 副武 天仪
local m=13257348
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
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(400)
	c:RegisterEffect(e1)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.indtg)
	e3:SetCountLimit(4)
	e3:SetValue(cm.valcon)
	c:RegisterEffect(e3)
	--cannot be destroyed
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_EQUIP)
	--e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	--e3:SetValue(cm.valcon)
	--e3:SetCountLimit(1)
	--c:RegisterEffect(e3)
	
end
function cm.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x6352)
end
function cm.indtg(e,c)
	local bool=e:GetHandler():GetEquipTarget()==c or (e:GetHandler():GetEquipTarget() and e:GetHandler():GetEquipTarget():GetEquipGroup():IsContains(c))
	if bool then Duel.HintSelection(Group.CreateGroup(c)) end
	return bool and Duel.SelectYesNo(e:GetHandler():GetControler(),aux.Stringid(m,0))
end
function cm.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
