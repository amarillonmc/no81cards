--时光酒桌 辰月
local m=60002011
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60002009") end) then require("script/c60002009") end
function cm.initial_effect(c)
	local e1=timeTable.set(c,m,cm.extraMove)
	local e2=timeTable.spsummon(c,m,cm.extra3,cm.extra5)
	timeTable.globle(c)
end
--e1
function cm.extraMove(e,tp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		Duel.BreakEffect()
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end
--e2
function cm.extra3(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x629))
	e1:SetValue(1000)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.extra5(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(m)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)  
end