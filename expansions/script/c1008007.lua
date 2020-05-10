--罪恶王冠 樱满真名
function c1008007.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c1008007.actcon)
	e1:SetOperation(c1008007.actop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x520e))
	e2:SetValue(c1008007.efilter)
	c:RegisterEffect(e2)
	--send to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c1008007.target)
	e4:SetOperation(c1008007.operation)
	c:RegisterEffect(e4)
end
function c1008007.actcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc and tc:IsControler(tp) and tc:IsSetCard(0x320e)
end
function c1008007.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c1008007.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() --and re:IsActiveType(TYPE_SPELL)
end
function c1008007.reptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE end
	return true
end
function c1008007.repoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c1008007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleTohand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleTohand,tp,0,LOCATION_MZONE,1,nil)
	and Duel.IsExistingTarget(c1008007.xfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsAbleTohand,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c1008007.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	if tc:IsControler(1-tp) then seq=seq+16 end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetLabel(seq)
		e1:SetCondition(c1008007.discon)
		e1:SetOperation(c1008007.disop)
		e1:SetReset(0)
		Duel.RegisterEffect(e1,tp)
	end
end
function c1008007.xfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x320e)
end
function c1008007.discon(e)
	if Duel.IsExistingMatchingCard(c1008007.xfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) then
		return true
	end
	e:Reset()
	return false
end
function c1008007.disop(e,tp)
	return bit.lshift(0x1,e:GetLabel())
end
function c1008007.voidfilter(c)
	return c:IsSetCard(0x320e) and c:IsFaceup()
end
function c1008007.voidtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c1008007.voidfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():IsFaceup() end
	Duel.Hint(8,tp,1008007)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,c1008007.voidfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c1008007.voidop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 or not c:IsRelateToEffect(e) then return end
	if not c:IsLocation(LOCATION_MZONE) or not c:IsFaceup() then return end
	local eqc=Duel.GetFirstTarget()
	if eqc:IsRelateToEffect(e) then
		c:RegisterFlagEffect(10080011,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1008001,4))
		local code = 1008009
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g=Group.FromCards(Duel.CreateToken(tp,code))
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.BreakEffect()
		Duel.Equip(tp,tc,eqc,true)
		c:SetCardTarget(tc)
		--Destroy
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetOperation(c1008007.desop)
		c:RegisterEffect(e2,true)
		--Destroy2
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetCondition(c1008007.descon2)
		e3:SetOperation(c1008007.desop2)
		c:RegisterEffect(e3,true)
	end
end
function c1008007.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_ONFIELD) then
		Duel.Destroy(tc,REASON_RULE)
	end
end
function c1008007.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and re and not re:GetHandler():IsSetCard(0x320e)
end
function c1008007.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end