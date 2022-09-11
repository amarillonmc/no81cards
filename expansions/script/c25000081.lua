local m=25000081
local cm=_G["c"..m]
cm.name="ZGMF-X19A 无限正义"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.postg)
	e1:SetOperation(cm.posop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(cm.con1)
	e2:SetOperation(cm.damop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.con2)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
end
cm.material_type=TYPE_SYNCHRO
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 and c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK) and c:IsAttackable() and Duel.IsExistingMatchingCard(function(c,tc)return c:IsCanBeBattleTarget(tc)end,tp,0,LOCATION_MZONE,1,nil,c) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local bc=Duel.SelectMatchingCard(tp,function(c,tc)return c:IsCanBeBattleTarget(tc)end,tp,0,LOCATION_MZONE,1,1,nil,c):GetFirst()
	if bc then
		Duel.CalculateDamage(c,bc)
	end
	end
end
function cm.con1(e)
	return e:GetHandler():IsAttackPos() and aux.bdocon(e,tp,eg,ep,ev,re,r,rp)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,e:GetHandler():GetBaseAttack(),REASON_EFFECT)
end
function cm.con2(e)
	return e:GetHandler():IsDefensePos()
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetHandler() then
		Duel.SetChainLimit(function(e,rp,tp)return tp==rp end)
	end
end
