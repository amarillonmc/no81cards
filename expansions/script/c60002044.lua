--Re_SURGUM 终焉的防线
local m=60002044
local cm=_G["c"..m]
cm.name="Re:SURGUM 终焉的防线"
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--match kill
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_MATCH_KILL)
	c:RegisterEffect(e4)
end
function cm.imfilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.atkval(e,c)
	return c:GetAttack()*100
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or ph==PHASE_DRAW or ph==PHASE_STANDBY or ph==PHASE_END)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAttackable() end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.imfilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if c:GetFlagEffect(m)~=100 then 
		--atk*2 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(cm.atkval)
		c:RegisterEffect(e1)
		end
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
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