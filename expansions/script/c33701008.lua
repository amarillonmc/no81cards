--带着伤悲感与残星倩影做朋友吧
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33701008
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsss.CounterFunction(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(cm.damval)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetCode(EFFECT_REFLECT_DAMAGE)
	e6:SetCondition(cm.con(7))
	e6:SetValue(1)
	c:RegisterEffect(e6)   
end
function cm.con(ct)
	return function(e)
		local tp=e:GetHandlerPlayer()
		return Duel.GetCounter(tp,1,1,0x1a)>=ct
	end
end
function cm.damval(e,re,val,r,rp,rc)
	if cm.con(7)(e) then return val end
	if r&REASON_EFFECT ~=0 and cm.con(3)(e) then return 1 end
	if r&REASON_BATTLE ~=0 and cm.con(5)(e) then return 1 end
	return val
end
