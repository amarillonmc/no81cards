--G-神智龙 弗尔布雷·多雷克斯
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16107116,"GODONOVADORA")
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,nil,nil,3,99)  
	c:EnableReviveLimit()
	--immune spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.effcon)
	e1:SetValue(cm.efilter)
   -- c:RegisterEffect(e1)
end
function cm.effcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end