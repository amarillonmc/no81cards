function c10111159.initial_effect(c)
	--tohand and spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111159,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c10111159.spcon)
	e1:SetTarget(c10111159.sptg)
	e1:SetOperation(c10111159.spop)
	c:RegisterEffect(e1)
    	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c10111159.handcon)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10111159,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,10111159)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c10111159.thtg)
	e3:SetOperation(c10111159.thop)
	c:RegisterEffect(e3)
end
function c10111159.thfilter(c,tp,e)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function c10111159.spcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c10111159.thfilter,1,nil,tp,e)
end
function c10111159.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if chkc then return eg:IsContains(chkc) and c10111159.thfilter(chkc,tp,e) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:FilterSelect(tp,c10111159.thfilter,1,1,nil,tp,e)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c10111159.spfilter(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10111159.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c10111159.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10111159,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c10111159.filter(c)
	return c:IsSetCard(0x5b) and c:IsFaceup()
end
function c10111159.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10111159.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c10111159.thfilter(c)
	return c:IsSetCard(0x5b) and c:IsAbleToHand()
end
function c10111159.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10111159.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10111159.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c10111159.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c10111159.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end