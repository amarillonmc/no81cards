--带着负罪感与残星倩影做朋友吧
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33701006
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsss.CounterFunction(c)
	local e3=rsef.FV_LIMIT(c,"dis",nil,aux.TargetBoolFunction(Card.IsPosition,POS_FACEUP_DEFENSE),{0,LOCATION_MZONE },cm.con(3))
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_MSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.con(5))
	e4:SetTargetRange(0,1)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	c:RegisterEffect(e4)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetTarget(cm.sumlimit)
	c:RegisterEffect(e7)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SSET)
	e5:SetCondition(cm.con(7))
	e5:SetTarget(aux.TRUE)  
	c:RegisterEffect(e5)
	local e8=e4:Clone()
	e8:SetCode(EFFECT_CANNOT_TURN_SET)
	e8:SetCondition(cm.con(7))
	e8:SetTarget(aux.TRUE)  
	c:RegisterEffect(e8)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return sumpos&POS_FACEDOWN >0
end
function cm.con(ct)
	return function(e)
		local tp=e:GetHandlerPlayer()
		return Duel.GetCounter(tp,1,1,0x1a)>=ct
	end
end
