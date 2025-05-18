--监视鸟遣使 影潜者 奥恩法
function c9911632.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9911632)
	e1:SetCondition(c9911632.condition)
	e1:SetTarget(c9911632.target)
	e1:SetOperation(c9911632.activate)
	c:RegisterEffect(e1)
	--transform
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c9911632.transcon)
	e2:SetOperation(c9911632.transop)
	c:RegisterEffect(e2)
end
function c9911632.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c9911632.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9911632,0xaf1b,TYPES_EFFECT_TRAP_MONSTER,1600,0,4,RACE_WARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911632.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and c:GetOriginalCode()==9911632 then
		c:SetEntityCode(40011513)
		c:ReplaceEffect(40011513,0,0)
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
			and Duel.IsEnvironment(40011525,tp,LOCATION_FZONE)
			and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(40011513,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function c9911632.transcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalCode()==9911632
end
function c9911632.transop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(40011513)
	c:ReplaceEffect(40011513,0,0)
end
