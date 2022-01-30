--蛊惑匪魔
function c9910928.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCondition(c9910928.indcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,9910928)
	e3:SetTarget(c9910928.damtg)
	e3:SetOperation(c9910928.damop)
	c:RegisterEffect(e3)
end
function c9910928.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND) and c:IsLevelAbove(7)
end
function c9910928.indcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c9910928.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910928.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c9910928.filter(c,e)
	return c:IsFaceup() and c:IsPosition(POS_ATTACK) and not c:IsImmuneToEffect(e)
end
function c9910928.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910928.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if Duel.Damage(1-tp,300,REASON_EFFECT)~=0 and Duel.GetCurrentChain()>1 and #g>1
		and g:IsExists(Card.IsAttackable,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9910928,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910928,1))
		local ac=g:FilterSelect(tp,Card.IsAttackable,1,1,nil):GetFirst()
		if not ac then return end
		g:RemoveCard(ac)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910928,2))
		local bc=g:Select(tp,1,1,nil):GetFirst()
		if not bc then return end
		Duel.CalculateDamage(ac,bc)
	end
end
