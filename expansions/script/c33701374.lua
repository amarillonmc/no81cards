--烈天的一击
local m=33701374
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		cm[2]=0
		cm[3]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(cm.clear)
		Duel.RegisterEffect(ge3,0)
	end
	
end
function cm.cfilter(c)
	return c:IsFaceup() and (c:IsRace(RACE_PSYCHO) or c:IsRace(RACE_MACHINE))
end
function cm.tgfilter(c,tc)
	return c:IsFaceup() and (c:IsAttackBelow(tc:GetAttack()) or c:IsDefenseBelow(tc:GetDefense()))
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)==1
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.cfilter(chkc) end
	if chk==0 then return g:GetCount()==ct and ct==1 and g:GetFirst():IsCanBeEffectTarget(e) end
	local tc=g:GetFirst()
	e:SetTargetCard(tc)
	local sg=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#sg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetFirstTarget()
	local c=e:GetHandler()
	if not tc:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(tc:GetAttack()*2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	tc:RegisterEffect(e2)

	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(g,REASON_EFFECT)
		g=Duel.GetOperatedGroup()
	end

	if cm[tp+2]==0 then
		local maxAtk=0
		local sg=Group.CreateGroup()
		if g:GetCount()>0 then
			sg,maxAtk=g:GetMaxGroup(Card.GetAttack)
		end
		if maxAtk<tc:GetAttack() then maxAtk=tc:GetAttack() end
		if maxAtk<tc:GetDefense() then maxAtk=tc:GetDefense() end
		Duel.BreakEffect()
		Duel.Damage(tp,maxAtk,REASON_EFFECT)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if 1-ep==rp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		cm[ep]=cm[ep]+ev
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	if cm[0]>=4000 then cm[2]=1 else cm[2]=0 end
	if cm[1]>=4000 then cm[3]=1 else cm[3]=0 end
	cm[0]=0
	cm[1]=0
end
