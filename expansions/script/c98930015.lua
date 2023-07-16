--超古代的炎魔
function c98930015.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c98930015.matfilter,2,true) 
	 --d1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98930015,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98930015)
	e1:SetCost(c98930015.cost)
	e1:SetCondition(c98930015.rmcon)
	e1:SetTarget(c98930015.rmtg)
	e1:SetOperation(c98930015.rmop)
	c:RegisterEffect(e1)
	--d2
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98930015,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98940015)
	e1:SetCost(c98930015.cost)
	e1:SetCondition(c98930015.rmcon2)
	e1:SetTarget(c98930015.rmtg2)
	e1:SetOperation(c98930015.rmop2)
	c:RegisterEffect(e1) 
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98930015,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98960015)
	e2:SetCost(c98930015.cost)
	e2:SetCondition(c98930015.immcon)
	e2:SetOperation(c98930015.immop)
	c:RegisterEffect(e2)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98930015,2))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c98930015.descon)
	e6:SetTarget(c98930015.destg)
	e6:SetOperation(c98930015.desop)
	c:RegisterEffect(e6) 
end
function c98930015.matfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0xad0)
end
function c98930015.cfilter(c)
	return c:IsSetCard(0xad0) and c:IsAbleToRemoveAsCost()
end
function c98930015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(98930015)==0
		and Duel.IsExistingMatchingCard(c98930015.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98930015.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(98930015,RESET_CHAIN,0,1)
end
function c98930015.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c98930015.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and rc:IsAbleToRemove() and not rc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
end
function c98930015.rmop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(500)
		c:RegisterEffect(e1)
	end
end
function c98930015.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_TRAP+TYPE_SPELL)
end
function c98930015.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and rc:IsAbleToRemove() and not rc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
end
function c98930015.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(500)
		c:RegisterEffect(e1)
	end
end
function c98930015.immcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c98930015.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESET_CHAIN)
		e1:SetValue(c98930015.efilter)
		e1:SetLabelObject(re)
		c:RegisterEffect(e1)
	end
end
function c98930015.efilter(e,re)
	return re==e:GetLabelObject()
end
function c98930015.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingTarget(c98930015.afilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack())
end
function c98930015.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c98930015.afilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk and c:GetDefense()>atk
end
function c98930015.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end