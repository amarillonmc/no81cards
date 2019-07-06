--残星倩影 瞬念开辟
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33700995
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsss.TargetFunction(c)
	rsss.DirectAttackFun(c,cm.con)
	rsss.DamageFunction(c,cm.op) 
end
function cm.con(e)
	local tp=e:GetHandlerPlayer()
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	return #g2>#g1
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local rct=1
	if Duel.GetTurnPlayer()==tp then rct=2 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(rsreset.pend+RESET_SELF_TURN,rct)
	e1:SetTarget(cm.sumtg)
	e1:SetOwnerPlayer(tp)
	e1:SetTargetRange(0,1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetReset(rsreset.pend+RESET_SELF_TURN,rct)
	e2:SetValue(cm.aclimit)
	e2:SetOwnerPlayer(tp)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_CHANGE_POS_E)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetReset(rsreset.pend+RESET_SELF_TURN,rct)
	e3:SetTarget(cm.sumtg)
	e3:SetOwnerPlayer(tp)
	e3:SetTargetRange(0,1)
	Duel.RegisterEffect(e3,tp)
end
function cm.sumtg(e,c)
	return c:IsControler(1-e:GetOwnerPlayer()) 
end
function cm.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return not rc:IsImmuneToEffect(e) and rc:IsFacedown() and rc:IsOnField() and rc:IsControler(1-e:GetOwnerPlayer())
end
