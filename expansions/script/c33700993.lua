--残星倩影 道路开辟
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33700993
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsss.TargetFunction(c)
	rsss.DirectAttackFun(c,cm.con)
	rsss.DamageFunction(c,cm.op)
end
function cm.con(e)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,1,nil)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_MSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetReset(rsreset.pend)
	e4:SetTargetRange(0,1)
	e4:SetTarget(aux.TRUE)
	Duel.RegisterEffect(e4,tp)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SSET)
	Duel.RegisterEffect(e8,tp)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_TURN_SET)
	Duel.RegisterEffect(e6,tp)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetTarget(cm.sumlimit)
	Duel.RegisterEffect(e7,tp)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return sumpos&POS_FACEDOWN >0
end