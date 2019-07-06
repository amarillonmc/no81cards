--残星倩影 读天时
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33700999
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	rsss.MatFunction(c,cm.fun)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_TUNER),2)
	cm.fun(c) 
end
function cm.fun(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(cm.tgcon)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	return e1
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsRelateToBattle() and not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),33701004)
end
function cm.tgop(e)
	Duel.Hint(HINT_CARD,0,m)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
