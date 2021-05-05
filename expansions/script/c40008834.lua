--凶饿蛊龙
function c40008834.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c40008834.ffilter,2,false)
	aux.EnablePendulumAttribute(c,false)   
	--reduce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008834,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c40008834.rdcon)
	e1:SetOperation(c40008834.rdop)
	c:RegisterEffect(e1) 
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c40008834.atktg)
	e2:SetValue(c40008834.atkval)
	c:RegisterEffect(e2)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1)
	e4:SetTarget(c40008834.cttg)
	e4:SetOperation(c40008834.ctop)
	c:RegisterEffect(e4)
	--copy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40008834,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c40008834.sccon)
	e5:SetCost(c40008834.copycost)
	e5:SetTarget(c40008834.copytg)
	e5:SetOperation(c40008834.copyop)
	c:RegisterEffect(e5)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(40008834,4))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c40008834.pencon)
	e6:SetTarget(c40008834.pentg)
	e6:SetOperation(c40008834.penop)
	c:RegisterEffect(e6)
end
function c40008834.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsFusionType(TYPE_PENDULUM)
end
function c40008834.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return ep==tp and tc and tc:IsType(TYPE_PENDULUM)
end
function c40008834.rdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(40008834,2)) then
		Duel.ChangeBattleDamage(tp,0)
	end
end
function c40008834.atktg(e,c)
	return not (c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK))
end
function c40008834.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x104f)*-200
end
function c40008834.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x104f,1)
end
function c40008834.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008834.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x104f)
end
function c40008834.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c40008834.ctfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x104f,1)
		tc=g:GetNext()
	end
end
function c40008834.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c40008834.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c40008834.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c40008834.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c40008834.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(40008834)==0 end
	e:GetHandler():RegisterFlagEffect(40008834,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c40008834.copyfilter(c)
	return c:IsFaceup() and aux.disfilter1(c) 
end
function c40008834.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c40008834.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40008834.copyfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40008834.copyfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SelectTarget(tp,c40008834.copyfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c40008834.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and not tc:IsDisabled() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN) then
		local code=tc:GetOriginalCodeRule()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EFFECT_CHANGE_CODE)
		e4:SetValue(code)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		end
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(40008834,3))
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e5:SetCode(EVENT_PHASE+PHASE_END)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCountLimit(1)
		e5:SetLabelObject(e1)
		e5:SetLabel(cid)
		e5:SetOperation(c40008834.rstop)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e5)
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			Duel.BreakEffect()
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_UPDATE_ATTACK)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD)
			e6:SetValue(-500)
			tc:RegisterEffect(e6)
			Duel.Damage(1-tp,500,REASON_EFFECT)
		end
	end
end
function c40008834.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end