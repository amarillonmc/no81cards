local m=15004109
local cm=_G["c"..m]
cm.name="律·深渊终章"
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.NonTuner(nil),1,99,cm.syncheck)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.negcon)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.atktg)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
	--Level:?
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.etg)
	e3:SetOperation(cm.eop)
	c:RegisterEffect(e3)
end
function cm.syncheck(g)
	return g:GetClassCount(Card.GetOriginalAttribute)==g:GetCount()
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAttackAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),1) end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAttackAbove,tp,LOCATION_MZONE,LOCATION_MZONE,c,1)
	local dg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
function cm.cefilter(c,ct)
	return Duel.CheckChainTarget(ct,c)
end
function cm.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		return ev and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg and tg:GetCount()==1 and re:IsActivated() and Duel.IsExistingTarget(cm.cefilter,tp,0xff,0xff,1,tg,ev)
	end
end
function cm.eop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local ag=Duel.GetMatchingGroup(cm.cefilter,tp,0xff,0xff,tg,ev)
	if ag:GetCount()~=0 then
		Duel.Hint(HINT_CARD,tp,m)
		local bg=ag:RandomSelect(tp,1)
		Duel.HintSelection(bg)
		Duel.ChangeTargetCard(ev,bg)
	end
end