--时光酒桌 荷月
local m=60002014
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60002009") end) then require("script/c60002009") end
function cm.initial_effect(c)
	local e1=timeTable.set(c,m,cm.extraMove)
	local e2=timeTable.spsummon(c,m,cm.extra3,cm.extra5)
	timeTable.globle(c)
end
--e1
function cm.cpfil(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function cm.extraMove(e,tp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.cpfil,tp,0,LOCATION_MZONE,1,nil) and  Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		Duel.BreakEffect()
		local pc=Duel.SelectMatchingCard(tp,cm.cpfil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		Duel.ChangePosition(pc,POS_FACEUP_DEFENSE)
	end
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
end
--e2
function cm.extra3(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x629))
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function cm.extra5(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(2)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end