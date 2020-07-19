--方舟骑士-红豆
local m=14010201
local cm=_G["c"..m]
cm.named_with_Arknight=1
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAttackable() end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsAttackable() or not c:IsRelateToEffect(e) then return end 
	value=c:GetAttack()
	ef=c:IsHasEffect(EFFECT_DEFENSE_ATTACK)
	if ef and ef:GetValue()==1 then 
		value=c:GetDefense()
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_AVOID_BATTLE_DAMAGE) then
		value=0
	end
	if Duel.Damage(1-tp,value,REASON_BATTLE) then
		Duel.Damage(1-tp,Duel.GetLP(1-tp),REASON_RULE)
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d and d~=e:GetHandler() then
		Duel.Destroy(d,REASON_EFFECT) 
	else
		Duel.Damage(1-tp,Duel.GetLP(1-tp),REASON_RULE)
	end
end