--龙炉点火：太祖龙
function c76200248.initial_effect(c)
	--decrease attack
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,76200248)
	e1:SetCondition(c76200248.atkcon)
	e1:SetTarget(c76200248.atktg)
	e1:SetOperation(c76200248.atkop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,76200248+1)
	e2:SetTarget(c76200248.target)
	e2:SetOperation(c76200248.operation)
	c:RegisterEffect(e2)
end
function c76200248.atkfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x725a) and c:IsType(TYPE_XYZ)
end
function c76200248.atkfilter2(c,tp)
	return c:IsControler(1-tp) and c:IsOnField() and c:IsFaceup() and c:GetAttack()>0
end
function c76200248.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d or a:GetControler()==d:GetControler() or d:IsFacedown() or a:IsFacedown() then return end
	local g=Group.FromCards(a,d)
	if g:IsExists(c76200248.atkfilter,1,nil,tp) and g:IsExists(c76200248.atkfilter2,1,nil,tp) then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
end
function c76200248.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if chk==0 then return #g==2 end
	Duel.SetTargetCard(g)
end
function c76200248.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(Card.IsRelateToEffect,nil,e)
	local tc1=g:Filter(c76200248.atkfilter,nil,tp):GetFirst()
	local tc2=g:Filter(c76200248.atkfilter2,nil,tp):GetFirst()
	if tc1 and tc2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc2:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		tc1:RegisterEffect(e1)
	end
end
function c76200248.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c76200248.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c76200248.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c76200248.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c76200248.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c76200248.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_REMOVE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(1,1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e2:SetTarget(c76200248.rmlimit)
		tc:RegisterEffect(e2)
	end
end
function c76200248.rmlimit(e,c,tp,r)
	return c==e:GetHandler() and r==REASON_EFFECT
end