--大宇宙勇机 雄伟疾驰
function c40009242.initial_effect(c)
	c:EnableCounterPermit(0x1f1b)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetDescription(aux.Stringid(40009242,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c40009242.ctcon)
	e1:SetCost(c40009242.ctcost)
	e1:SetTarget(c40009242.cttg)
	e1:SetOperation(c40009242.ctop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c40009242.efcon)
	e2:SetOperation(c40009242.efop)
	c:RegisterEffect(e2)
end
function c40009242.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_DAMAGE and Duel.GetBattleMonster(tp)==c and not Duel.IsDamageCalculated() and c:IsAttackAbove(c:GetBaseAttack()+2000)
end
function c40009242.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009242.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x1f1b,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1f1b)
end
function c40009242.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x1f1b,1)
	end
	local g=Duel.GetMatchingGroup(c40009242.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(40009242,2))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c40009242.damcon)
		e1:SetOperation(c40009242.damop)
		tc:RegisterEffect(e1)
	end
end
function c40009242.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetCounter(0x1f1b)>0
end
function c40009242.damop(e,tp)
	Duel.Hint(HINT_CARD,0,40009242)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1f1b)
	local atk=c:GetAttack() 
	if atk<=0 then return end
	for i=1,ct do 
		Duel.Damage(1-tp,atk,REASON_EFFECT)
		if Duel.GetLP(1-tp)<=0 then return end
	end
end
function c40009242.ctfilter(c)
	return c:GetCounter(0x1f1b)>0
end
function c40009242.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c40009242.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(40009242,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c40009242.atkcon)
	e1:SetOperation(c40009242.atkop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c40009242.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40009242.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end