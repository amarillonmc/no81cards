--重装之圣冰 开花菲约尔姆
function c75099013.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,aux.Tuner(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75099013,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c75099013.nbcon)
	e3:SetTarget(aux.nbtg)
	e3:SetOperation(c75099013.nbop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,75099014)
	e4:SetCondition(c75099013.dacon)
	e4:SetTarget(c75099013.datg)
	e4:SetOperation(c75099013.daop)
	c:RegisterEffect(e4)
c75099013.frozen_list=true
end
function c75099013.nbcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev) and re:GetHandler():GetCounter(0x1750)>0 and re:GetHandler():IsCanAddCounter(0x1750,1)
end
function c75099013.nbop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(e) and rc:IsFaceup() and rc:AddCounter(0x1750,1) and rc:GetFlagEffect(75099001)==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c75099013.frcon)
		e1:SetValue(rc:GetAttack()*-1/4)
		rc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(rc:GetDefense()*-1/4)
		rc:RegisterEffect(e2)
		rc:RegisterFlagEffect(75099001,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c75099013.frcon(e)
	return e:GetHandler():GetCounter(0x1750)>0
end
function c75099013.dacon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c75099013.dafilter(c)
	return c:IsFaceup() and (c:GetAttack()<c:GetBaseAttack() or c:GetDefense()<c:GetBaseDefense())
end
function c75099013.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c75099013.dafilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	local val=g:GetSum(Card.GetBaseAttack)+g:GetSum(Card.GetBaseDefense)-g:GetSum(Card.GetAttack)-g:GetSum(Card.GetDefense)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
end
function c75099013.daop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c75099013.dafilter,tp,0,LOCATION_MZONE,nil)
	local val=g:GetSum(Card.GetBaseAttack)+g:GetSum(Card.GetBaseDefense)-g:GetSum(Card.GetAttack)-g:GetSum(Card.GetDefense)
	Duel.Damage(1-tp,val,REASON_EFFECT)
end
