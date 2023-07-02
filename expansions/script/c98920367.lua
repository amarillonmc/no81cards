--英豪挑战者 巨盾兵
function c98920367.initial_effect(c)
	  --negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920367,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920367)
	e1:SetCondition(c98920367.condition)
	e1:SetTarget(c98920367.target)
	e1:SetOperation(c98920367.operation)
	c:RegisterEffect(e1)
	  --negate effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920367,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98920367)
	e2:SetCondition(c98920367.negcon)
	e2:SetTarget(c98920367.negtg)
	e2:SetOperation(c98920367.negop)
	c:RegisterEffect(e2)
	--atk limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c98920367.atklimit)
	c:RegisterEffect(e3)
end
function c98920367.atklimit(e,c)
	return c~=e:GetHandler()
end
function c98920367.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6f)
end
function c98920367.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return at:IsControler(1-tp) and ct>0 and ct==Duel.GetMatchingGroupCount(c98920367.cfilter,tp,LOCATION_MZONE,0,nil)
end
function c98920367.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c98920367.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.NegateAttack()
	end
end
function c98920367.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==Duel.GetMatchingGroupCount(c98920367.cfilter,tp,LOCATION_MZONE,0,nil)
end
function c98920367.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c98920367.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
	   Duel.NegateEffect(ev)
	end
end