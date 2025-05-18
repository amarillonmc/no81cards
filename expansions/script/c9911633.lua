--齐驱之刃 影潜者 奥纽克斯
function c9911633.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9911633)
	e1:SetCondition(c9911633.condition)
	e1:SetTarget(c9911633.target)
	e1:SetOperation(c9911633.activate)
	c:RegisterEffect(e1)
	--transform
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c9911633.transcon)
	e2:SetOperation(c9911633.transop)
	c:RegisterEffect(e2)
end
function c9911633.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev)
end
function c9911633.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9911633,0xaf1b,TYPES_EFFECT_TRAP_MONSTER,1900,0,5,RACE_WARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911633.tgfilter(c)
	return c:IsSetCard(0xaf1b) and c:IsAbleToGrave()
end
function c9911633.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and c:GetOriginalCode()==9911633 then
		c:SetEntityCode(40011516)
		c:ReplaceEffect(40011516,0,0)
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
			and Duel.IsEnvironment(40011525,tp,LOCATION_FZONE)
			and Duel.IsExistingMatchingCard(c9911633.tgfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(40011516,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,c9911633.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
function c9911633.transcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalCode()==9911633
end
function c9911633.transop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(40011516)
	c:ReplaceEffect(40011516,0,0)
end
