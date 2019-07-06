--带着孤独感与残星倩影做朋友吧
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33701007
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsss.CounterFunction(c)
	local e4=rsef.FV_LIMIT(c,"atk",nil,cm.cfilter,{0,LOCATION_MZONE },cm.con(5))
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(cm.con(3))
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(cm.sumlimit)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetCondition(cm.con(7))
	c:RegisterEffect(e5)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return sumpos&POS_ATTACK >0 and c:IsLocation(LOCATION_EXTRA)
end
function cm.con(ct)
	return function(e)
		local tp=e:GetHandlerPlayer()
		return Duel.GetCounter(tp,1,1,0x1a)>=ct
	end
end
