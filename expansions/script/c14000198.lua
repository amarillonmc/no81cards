--噬界兽 LV13-寰宇形态
local m=14000198
local cm=_G["c"..m]
cm.named_with_Worlde=1
function cm.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.sumcon)
	e3:SetOperation(cm.sumsuc)
	c:RegisterEffect(e3)
	if not cm.global_flag then
		cm.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
cm.lvup={14000206}
cm.lvdn={14000200,14000201,14000202,14000203,14000204,14000205,14000206}
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(14000206) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),14000206,0,0,0)
		end
	end
end
function cm.splimit(e,se,sp,st)
	local tp=e:GetHandlerPlayer()
	return se:IsHasType(EFFECT_TYPE_ACTIONS)--Duel.GetFlagEffect(tp,14000206)>0
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d and d~=e:GetHandler() then
		Duel.Destroy(d,REASON_EFFECT) 
	else
		Duel.Damage(1-tp,Duel.GetLP(1-tp),REASON_RULE)
	end
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackable() and Duel.GetFlagEffect(tp,14000206)>0
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
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