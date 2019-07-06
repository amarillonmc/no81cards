--那残星倩影识得千花万树红
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33701004
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsss.TargetFunction(c)
	local e1=rsef.ACT(c)
	local e2=rsss.ActFieldFunction(c,m)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(m)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLE_CONFIRM)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(cm.tgcon)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
end
function cm.cfilter(c,tp)
	return c:IsSetCard(0x144d) and c:IsFaceup() and c:IsControler(tp)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	return (ac and cm.cfilter(ac,tp)) or (bc and cm.cfilter(bc,tp))
end
function cm.tgop(e,tp)
	Duel.Hint(HINT_CARD,0,m)
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	local tc=ac
	if not cm.cfilter(ac,tp) then tc=bc end
	Duel.SendtoGrave(tc,REASON_EFFECT)
end

