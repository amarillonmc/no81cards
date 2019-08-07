--应急核心
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local m=10130011
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e4=rsqd.ContinuousFun(c)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.poscon)
	e2:SetOperation(cm.posop)
	c:RegisterEffect(e2)
	--defense attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa336))
	e3:SetValue(1)
	c:RegisterEffect(e3)	
end
function cm.checkfilter(c,tp)
	if not c then return false end
	return c:IsControler(tp) and c:IsSetCard(0xa336) and c:IsCanTurnSet() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.poscon(e,tp,eg)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return cm.checkfilter(a,tp) or cm.checkfilter(d,tp)
end
function cm.posop(e,tp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local list={a,d}
	local g=Group.CreateGroup()
	for _,tc in pairs(list) do
		if cm.checkfilter(tc,tp) then
			rsgf.Mix(g,tc)
		end
	end
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end