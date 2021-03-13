--晓光之剑烂 格吉特·莱特宁
function c40009514.initial_effect(c)
	aux.AddCodeList(c,40009510)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,40009510),aux.NonTuner(Card.IsRace,RACE_WARRIOR),1)
	c:EnableReviveLimit()
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c40009514.matcheck)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009514,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40009514)
	e2:SetCondition(c40009514.negcon)
	e2:SetTarget(c40009514.negtg)
	e2:SetOperation(c40009514.negop)
	c:RegisterEffect(e2) 
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40009514,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,40009515)
	e5:SetCondition(c40009514.descon)
	e5:SetTarget(c40009514.destg)
	e5:SetOperation(c40009514.desop)
	c:RegisterEffect(e5)  
end
function c40009514.matcheck(e,c)
	local ct=c:GetMaterialCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ct*200)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c40009514.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c40009514.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c40009514.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Damage(tp,rc:GetAttack(),REASON_EFFECT)
	end
end
function c40009514.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp 
end
function c40009514.filter(c,dam)
	return c:IsAttackBelow(dam) and c:IsFaceup()
end
function c40009514.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009514.filter,tp,0,LOCATION_MZONE,1,nil,ev) end
	local g=Duel.GetMatchingGroup(c40009514.filter,tp,0,LOCATION_MZONE,nil,ev)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0,nil,ev)
end
function c40009514.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c40009514.filter,tp,0,LOCATION_MZONE,nil,ev)
	Duel.Destroy(g,REASON_EFFECT)
end




