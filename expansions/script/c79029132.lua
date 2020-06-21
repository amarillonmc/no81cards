--维多利亚·近卫干员-慕斯
function c79029132.initial_effect(c)
	--Damage and discard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20785975,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c79029132.cost)
	e1:SetTarget(c79029132.target)
	e1:SetOperation(c79029132.operation)
	c:RegisterEffect(e1)
	 --Damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetTarget(c79029132.target1)
	e3:SetOperation(c79029132.operation1)
	c:RegisterEffect(e3)	
end
function c79029132.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c79029132.operation1(e,tp,eg,ep,ev,re,r,rp)
	 local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c79029132.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,4,REASON_COST)
end
function c79029132.filter(c)
	return c:IsFaceup() and not c:IsAttack(c:GetBaseAttack()) and c:IsAbleToRemove()
end
function c79029132.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c79029132.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029132.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c79029132.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local atk=math.abs(tc:GetAttack()-tc:GetBaseAttack())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,1,1-tp,atk)
end
function c79029132.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=math.abs(tc:GetAttack()-tc:GetBaseAttack())
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Damage(1-tp,atk,REASON_EFFECT)~0 then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(atk)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e:GetHandler():RegisterEffect(e4)
	if atk>=1000 then
	local a=g:RandomSelect(tp,1)
	Duel.SendtoGrave(a,REASON_EFFECT+REASON_DISCARD)
	if atk>=2000 then
	local a=g:RandomSelect(tp,1)
	Duel.SendtoGrave(a,REASON_EFFECT+REASON_DISCARD)
	if atk>=3000 then
	local a=g:RandomSelect(tp,1)
	Duel.SendtoGrave(a,REASON_EFFECT+REASON_DISCARD)
	end
end
end
end
end























