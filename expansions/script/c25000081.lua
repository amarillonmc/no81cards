local m=25000081
local cm=_G["c"..m]
cm.name="ZGMF-X19A 无限正义"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetTarget(cm.postg)
	e2:SetOperation(cm.posop)
	c:RegisterEffect(e2)
end
function cm.posfilter(c)
	return c:IsDefensePos() or c:IsFacedown()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	if Duel.ChangePosition(g,POS_FACEUP_ATTACK)==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local bc=Duel.SelectMatchingCard(tp,function(c)return c:GetOwner()~=tp end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and bc then
		if c:GetFlagEffect(m)>0 then cm.cbc(c,bc) end
		Duel.CalculateDamage(c,bc)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetOperation(cm.disop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.negop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,1)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() then return end
	local bc=c:GetBattleTarget()
	if bc then cm.cbc(c,bc) end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not Duel.IsChainDisablable(ev) then return end
	Duel.Hint(HINT_CARD,0,m)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then Duel.Destroy(re:GetHandler(),REASON_EFFECT) end
end
function cm.cbc(c,bc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	bc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	bc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetValue(0)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	bc:RegisterEffect(e3)
end
