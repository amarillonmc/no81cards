--至尊绝世的剑圣 龙马
local m=75000709
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	local e01=Effect.CreateEffect(c)
	e01:SetDescription(1164)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetCode(EFFECT_SPSUMMON_PROC)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetRange(LOCATION_EXTRA)
	e01:SetCondition(cm.syncon)
	e01:SetOperation(cm.synop)
	e01:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e01)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.ctcon)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1) 
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.damcon)
	e2:SetTarget(cm.damtg)
	e2:SetOperation(cm.damop)
	c:RegisterEffect(e2)
end
cm.toss_coin=true
--
function cm.SynchroMaterial(tc)
	if tc:GetSynchroType()&TYPE_MONSTER==0 or tc:GetType()&TYPE_LINK~=0 then return false end
	if tc:IsStatus(STATUS_FORBIDDEN) then return false end
	if tc:IsHasEffect(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL) then return false end
	return true 
end
function cm.GetSynMaterials(tp,syncard)
	local mg=Duel.GetMatchingGroup(cm.f,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp,syncard)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	return mg
end
--synchro summon
function cm.f(c,tp,tc)
	local b1=c:IsFaceup() and cm.SynchroMaterial(c)
	local b2=c:IsControler(1-tp) and (c:IsSetCard(0xe75) or c:IsHasEffect(EFFECT_SYNCHRO_MATERIAL))
	return c:IsLevelAbove(1) and b1 and (c:IsControler(tp) or b2)
end
function cm.f1(c)
	return c:IsSynchroType(TYPE_TUNER) 
end
function cm.f2(c)
	return not c:IsSynchroType(TYPE_TUNER)
end
function cm.f3(c,tp)
	return c:IsSetCard(0x750) and c:IsControler(1-tp) and not c:IsHasEffect(EFFECT_SYNCHRO_MATERIAL)
end
function cm.fs(g,tp,tc) 
	return g:FilterCount(cm.f3,nil,tp)<=1
		and g:FilterCount(cm.f1,nil)==1
		and g:GetSum(Card.GetSynchroLevel,tc)==tc:GetLevel()
		and g:FilterCount(cm.f2,nil)==#g-1   
		and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0
end
function cm.syncon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=cm.GetSynMaterials(tp,c)
	return g:CheckSubGroup(cm.fs,2,#g,tp,c)
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=cm.GetSynMaterials(tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local tg=g:SelectSubGroup(tp,cm.fs,false,2,#g,tp,c)
	c:SetMaterial(tg)
	Duel.SendtoGrave(tg,REASON_MATERIAL+REASON_SYNCHRO)
end
--Effect 1
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==tp and c:GetEffectCount(EFFECT_EXTRA_ATTACK_MONSTER)==0 
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e4:SetRange(LOCATION_MZONE)
		e4:SetValue(4)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4)
	end
end
--Effect 2
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and Duel.GetAttacker()==bc and Duel.GetAttackTarget()==c 
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local res=Duel.TossCoin(tp,1)
	if res~=1 then return end
	Duel.NegateAttack()
end