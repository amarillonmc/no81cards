--方舟骑士-幽灵鲨
c29072102.named_with_Arknight=1
function c29072102.initial_effect(c)
	--hand+mzone search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29072102,0))
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	--e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,29072102)
	e1:SetCondition(c29072102.con)
	e1:SetTarget(c29072102.thtg)
	e1:SetOperation(c29072102.thop)
	c:RegisterEffect(e1)
	--hand+mzone sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29072102,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	--e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,29072103)
	e3:SetCondition(c29072102.con)
	e3:SetTarget(c29072102.sptg)
	e3:SetOperation(c29072102.spop)
	c:RegisterEffect(e3)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c29072102.efilter)
	c:RegisterEffect(e3)
end
function c29072102.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated() and re:IsActiveType(TYPE_MONSTER) and re:GetOwner():IsAttribute(ATTRIBUTE_WATER)
end
function c29072102.con(e,tp,eg,ep,ev,re,r,rp)
	local attr=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTRIBUTE)
	return re:GetHandler()~=e:GetHandler() and re:IsActiveType(TYPE_MONSTER) and attr&ATTRIBUTE_WATER>0
end
--e1e2
function c29072102.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c29072102.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.SelectYesNo(tp,aux.Stringid(29072102,2)) then
			Duel.NegateEffect(ev)
		end
	end
end
--e3e4
function c29072102.thfilter(c)
	return c:IsSetCard(0x47af) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c29072102.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29072102.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29072102.thop(e,tp,eg,ep,ev,re,r,rp)
	--Duel.DisableShuffleCheck()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29072102.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end













