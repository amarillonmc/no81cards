local m=53796001
local cm=_G["c"..m]
cm.name="在海豚的梦中永别"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tc and tc:IsControler(tp) and tc:GetSequence()<5 and tc:IsAbleToRemove(tp,POS_FACEDOWN,REASON_RULE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.GetAttackTarget():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,Duel.GetAttackTarget(),1,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then Duel.SetChainLimit(aux.FALSE) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	local seq=at:GetSequence()
	if at:IsRelateToEffect(e) and at:IsControler(tp) and Duel.Remove(at,POS_FACEDOWN,REASON_RULE)~=0 and at:IsLocation(LOCATION_REMOVED) and at:IsFacedown() then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(1-tp,PHASE_END,RESET_PHASE+PHASE_END,1)
	end
	if Duel.GetFieldCard(tp,LOCATION_MZONE,seq) then return end
	local val=aux.SequenceToGlobal(tp,LOCATION_MZONE,seq)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(val)
	Duel.RegisterEffect(e1,tp)
end
