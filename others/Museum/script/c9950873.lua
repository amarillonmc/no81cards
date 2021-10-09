--逢魔一击
function c9950873.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c9950873.target)
	e1:SetOperation(c9950873.activate)
	c:RegisterEffect(e1)
end
function c9950873.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(5) and c:IsFusionSetCard(0xbca) and c:GetFlagEffect(9950873)==0
end
function c9950873.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950873.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c9950873.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	 local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c9950873.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c9950873.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetCategory(CATEGORY_ATKCHANGE)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_ATTACK_ANNOUNCE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetCondition(c9950873.atkcon)
		e2:SetCost(c9950873.atkcost)
		e2:SetTarget(c9950873.atktg)
		e2:SetOperation(c9950873.atkop)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(tc)
		e3:SetCategory(CATEGORY_TOGRAVE)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_BATTLED)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetCondition(c9950873.tgcon)
		e3:SetTarget(c9950873.tgtg)
		e3:SetOperation(c9950873.tgop)
		tc:RegisterEffect(e3)
		if not tc:IsType(TYPE_EFFECT) then
			local e4=Effect.CreateEffect(tc)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_TYPE)
			e4:SetValue(TYPE_EFFECT)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
		end
  --disable
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(c9950873.disop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BE_BATTLE_TARGET)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetTarget(c9950873.distg)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_DISABLE_EFFECT)
	   tc:RegisterEffect(e4)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c9950873.atkval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(9950873,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9950873,0))
	end
end
function c9950873.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c9950873.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
function c9950873.atkfilter(c,tp)
	return c:GetAttackAnnouncedCount()==0 and c:GetTextAttack()>0 and (c:IsControler(tp) or c:IsFaceup())
end
function c9950873.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	local g=Duel.GetReleaseGroup(tp):Filter(c9950873.atkfilter,e:GetHandler(),tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:Select(tp,1,g:GetCount(),nil)
	Duel.Release(rg,REASON_COST)
	local atk=rg:GetSum(Card.GetTextAttack)
	e:SetLabel(100,atk)
end
function c9950873.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local label,atk=e:GetLabel()
	if chk==0 then
		e:SetLabel(0,0)
		if label~=100 then return false end
		return true
	end
	e:SetLabel(0,0)
	Duel.SetTargetParam(atk)
end
function c9950873.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c9950873.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
function c9950873.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c9950873.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c9950873.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc then
		bc:RegisterFlagEffect(9950873,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
	end
end
function c9950873.distg(e,c)
	return c:GetFlagEffect(9950873)~=0
end
function c9950873.atkfilter2(c)
	return c:IsFaceup() and c:IsLevelAbove(4)
end
function c9950873.atkval(e,c)
	return Duel.GetMatchingGroupCount(c9950873.atkfilter2,c:GetControler(),LOCATION_GRAVE,0,nil)*500
end