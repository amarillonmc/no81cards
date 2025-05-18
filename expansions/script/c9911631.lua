--沉默的毒骑士 影潜者 莫达利昂
function c9911631.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9911631)
	e1:SetCondition(c9911631.condition)
	e1:SetTarget(c9911631.target)
	e1:SetOperation(c9911631.activate)
	c:RegisterEffect(e1)
	--transform
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c9911631.transcon)
	e2:SetOperation(c9911631.transop)
	c:RegisterEffect(e2)
end
function c9911631.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c9911631.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9911631,0xaf1b,TYPES_EFFECT_TRAP_MONSTER,2700,0,11,RACE_WARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911631.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and c:GetOriginalCode()==9911631 then
		c:SetEntityCode(40011510)
		c:ReplaceEffect(40011510,0,0)
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
			and Duel.IsEnvironment(40011525,tp,LOCATION_FZONE) then
			Duel.BreakEffect()
			Duel.Damage(1-tp,1200,REASON_EFFECT)
		end
	end
end
function c9911631.transcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalCode()==9911631
end
function c9911631.transop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(40011510)
	c:ReplaceEffect(40011510,0,0)
end
