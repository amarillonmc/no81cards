--闪耀的六出花 桑山千雪
function c28316347.initial_effect(c)
	--alstroemeria spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,28316347+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c28316347.sprcon)
	e1:SetOperation(c28316347.sprop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,28316347)
	e2:SetTarget(c28316347.rectg)
	e2:SetOperation(c28316347.recop)
	c:RegisterEffect(e2)
	c28316347.recover_effect=e2
end
function c28316347.sprcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>8000 and Duel.GetMZoneCount(tp)>0 and (c:IsLocation(LOCATION_HAND) or Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsAttribute),0,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_EARTH))
end
function c28316347.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	if c:IsLocation(LOCATION_HAND) then return end
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-2000)
end
function c28316347.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c28316347.thfilter(c)
	return c:IsSetCard(0x283) and c:IsLevel(4) and c:IsAbleToHand()
end
function c28316347.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
	local b1=Duel.GetLP(tp)>8000 and Duel.IsExistingMatchingCard(c28316347.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetLP(tp)>=10000 and Duel.IsExistingMatchingCard(Card.IsReleasableByEffect,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b3=true
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(28316347,0)},
		{b2,aux.Stringid(28316347,1)},
		{b3,aux.Stringid(28316347,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c28316347.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsSummonType(SUMMON_TYPE_NORMAL) and c:IsFaceup() and c:IsAttackPos() and Duel.SelectOption(tp,aux.Stringid(28316347,3),aux.Stringid(28316347,4))==0 then
			Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
		else
			local lp=Duel.GetLP(tp)
			Duel.SetLP(tp,lp-2000)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g)
		Duel.Release(g,REASON_EFFECT)
	end
end
