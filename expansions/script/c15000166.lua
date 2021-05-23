local m=15000166
local cm=_G["c"..m]
cm.name="律"
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.NonTuner(nil),1,99,cm.syncheck)
	c:EnableReviveLimit()
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(cm.atktg)
	e0:SetOperation(cm.atkop)
	c:RegisterEffect(e0)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.baop)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCondition(cm.becon)
	e2:SetTarget(cm.betg)
	e2:SetOperation(cm.beop)
	c:RegisterEffect(e2)
end
c15000166.toss_dice=true
function cm.syncheck(g)
	return g:GetClassCount(Card.GetOriginalAttribute)==g:GetCount()
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
		e1:SetValue(-800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
function cm.baop(e,tp,eg,ep,ev,re,r,rp)
	local ag=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())
	local d=Duel.TossDice(tp,1)
	if d<=4 then
		if Duel.NegateAttack() and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,ag) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local bg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,ag)
			Duel.Destroy(bg,REASON_EFFECT)
		end
	end
end
function cm.becon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:GetCount()==1 and g:GetFirst()==e:GetHandler()
end
function cm.cefilter(c,ct)
	return Duel.CheckChainTarget(ct,c)
end
function cm.betg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(cm.cefilter,tp,0xff,0xff,1,e:GetHandler(),ev) end
end
function cm.beop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	if d>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local ag=Duel.SelectMatchingCard(tp,cm.cefilter,tp,0xff,0xff,1,1,e:GetHandler(),ev)
		if ag:GetCount()~=0 then
			Duel.ChangeTargetCard(ev,ag)
		end
	end
end