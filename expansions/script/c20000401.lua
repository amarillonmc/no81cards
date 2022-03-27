--赤兽机艺•阎狐
local m=20000401
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000400") end) then require("script/c20000400") end
function cm.initial_effect(c)
	local e1=fu_hd.AttackTrigger(c,cm.Give)
end
function cm.Give(c)
	local tp=c:GetControler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.imcon)
	e1:SetValue(cm.efilter)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(fu_hd.GiveTarget)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
end
function cm.imcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function cm.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xfd4)
end