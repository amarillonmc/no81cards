--闪刀姬-燎里·疾速模式
function c63288533.initial_effect(c)
	c:SetSPSummonOnce(63288533)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c63288533.matfilter,1,1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(63288533,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetTarget(c63288533.atktg)
	e1:SetOperation(c63288533.atkop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(c63288533.actcon)
	c:RegisterEffect(e2)
end
function c63288533.matfilter(c)
	return c:IsLinkSetCard(0x1115) and c:IsLinkType(TYPE_LINK)
end
function c63288533.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c63288533.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and c:GetLinkedGroup():IsContains(bc) and c:GetFlagEffect(21887175)==0 end
	c:RegisterFlagEffect(21887175,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c63288533.atkfilter(c)
	return c:IsSetCard(0x1115) and c:IsType(TYPE_LINK)
end
function c63288533.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local g=Duel.GetMatchingGroup(c63288533.atkfilter,tp,LOCATION_GRAVE,0,nil)
	local atk=g:GetSum(Card.GetBaseAttack)
	if c:IsRelateToBattle() and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
end
