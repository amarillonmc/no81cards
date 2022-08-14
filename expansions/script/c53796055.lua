local m=53796055
local cm=_G["c"..m]
cm.name="全力以负"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(DOUBLE_DAMAGE)
	e2:SetCondition(function(e)return Duel.GetTurnPlayer()==e:GetHandlerPlayer()end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTargetRange(0,1)
	e3:SetCondition(function(e)return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()end)
	c:RegisterEffect(e3)
end
