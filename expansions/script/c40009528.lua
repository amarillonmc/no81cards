--真抹消者 后裔·Σ
function c40009528.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5f1b),aux.NonTuner(nil),1)
	c:EnableReviveLimit()  
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--damage val
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e8:SetValue(1)
	c:RegisterEffect(e8) 
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c40009528.atkcon)
	e2:SetOperation(c40009528.atkop)
	c:RegisterEffect(e2) 
end
function c40009528.atkcon(e)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,2,nil)
end
function c40009528.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(40009528,1)) then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_BATTLED)
		e1:SetTarget(c40009528.destg)
		e1:SetOperation(c40009528.desop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e1)
	end
end
function c40009528.desfilter(c,atk)
	return (c:IsAttackPos() and c:IsAttackBelow(atk)) or (c:IsFaceup() and c:IsDefensePos() and c:IsDefenseBelow(atk))
end
function c40009528.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c40009528.desfilter,tp,0,LOCATION_MZONE,nil,e:GetHandler():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c40009528.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c40009528.desfilter,tp,0,LOCATION_MZONE,nil,e:GetHandler():GetAttack())
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	--Duel.Destroy(g,REASON_EFFECT)
	--local pc=g:GetNext()
	local seq=0
	local pc=g:GetFirst()
	--while pc do 
	while seq<=6 do
		Duel.CalculateDamage(e:GetHandler(),pc)
		pc=g:GetNext()
		--pc=g:GetNext()
		--pc=g:GetFirst()
	end
	--pc=g:GetNext()
end


