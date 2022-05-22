local m=31417003
local cm=_G["c"..m]
cm.name="圣域歌姬-小橘"
if not pcall(function() require("expansions/script/c31417000") end) then require("expansions/script/c31417000") end
function cm.initial_effect(c)
	Seine_Vocaloid.enable(c,3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(cm.tgtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetTargetRange(0,LOCATION_SZONE)
	e3:SetValue(aux.tgsval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(aux.indsval)
	c:RegisterEffect(e4)
end
function cm.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function cm.tgtg(e,c)
	return c:GetSequence()<5 and c:GetColumnGroup():FilterCount(cm.tgfilter,nil,c:GetControler())>0
end