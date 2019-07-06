--虚毒概念 一元论
if not pcall(function() require("expansions/script/c33700701") end) then require("script/c33700701") end
local m=33700710
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsve.FusionMaterialFunction(c,3)
	rsve.ToGraveFunction(c,2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(cm.con)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x144b))
	e1:SetValue(500)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(cm.con2)
	e4:SetValue(1000)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)  
end
function cm.con(e)
	return e:GetHandler():IsType(TYPE_CONTINUOUS)
end
function cm.con2(e)
	return e:GetHandler():GetEquipTarget():IsSetCard(0x144b)
end