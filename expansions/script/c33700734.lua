--铁虹少女
if not pcall(function() require("expansions/script/c33700720") end) then require("script/c33700720") end
local m=33700734
local cm=_G["c"..m]
function cm.initial_effect(c)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetCondition(rsneov.LPCon2)
	e1:SetValue(cm.lvval)
	e1:SetLabel(-1)
	c:RegisterEffect(e1)  
	--def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetCondition(rsneov.LPCon2)
	e2:SetValue(cm.defval)
	c:RegisterEffect(e2)  
	local e3=e1:Clone()
	e3:SetCondition(rsneov.LPCon)
	e3:SetLabel(1)
	c:RegisterEffect(e3)  
	local e4=e2:Clone()
	e4:SetCondition(rsneov.LPCon)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	c:RegisterEffect(e4) 
end
function cm.lvval(e,c)
	local tp=c:GetControler()
	local ct=Duel.GetLP(1-tp)-Duel.GetLP(tp)
	local ct2=math.floor(ct/1000)
	local ct3=math.min(ct2,3)
	return ct3*e:GetLabel()
end
function cm.defval(e,c)
	local tp=c:GetControler()
	local ct=Duel.GetLP(1-tp)-Duel.GetLP(tp)
	local ct2=math.floor(ct/1000)
	local ct3=math.min(ct2,3)
	return ct3*500
end
