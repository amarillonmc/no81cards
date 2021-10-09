--AgitΩ·无限进化
function c9980432.initial_effect(c)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980432,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c9980432.target)
	e3:SetOperation(c9980432.operation)
	c:RegisterEffect(e3)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980432,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9980432.thtg)
	e2:SetOperation(c9980432.thop)
	c:RegisterEffect(e2)
end
function c9980432.filter(c,e,tp)
	return Duel.IsExistingMatchingCard(c9980432.chkfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetControler(),c:GetOriginalCodeRule())
end
function c9980432.chkfilter(c,e,tp,cc,code)
	return c:IsSetCard(0x5bca) and c:GetOriginalCodeRule()~=code and
		not c:IsHasEffect(EFFECT_REVIVE_LIMIT) and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,cc,c)
end
function c9980432.spfilter(c,e,tp,cc,code)
	return c:IsSetCard(0x5bca) and c:GetOriginalCodeRule()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,cc)
end
function c9980432.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9980432.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c9980432.filter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c9980432.filter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9980432.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9980432.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local cc=tc:GetControler()
	local code=tc:GetOriginalCodeRule()
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(cc,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9980432.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,cc,code)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980432,1))
			Duel.SpecialSummon(g,0,tp,cc,false,false,POS_FACEUP)
		end
	end
end
function c9980432.thfilter(c)
	return c:IsSetCard(0x5bca) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9980432.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980432.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9980432.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980432.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
