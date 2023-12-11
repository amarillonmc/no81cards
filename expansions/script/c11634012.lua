--钢素枪管龙
function c11634012.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_DRAGON),2,2,c11634012.lcheck)
	c:EnableReviveLimit()
	  --destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,11634012)
	e4:SetCondition(c11634012.descon)
	e4:SetTarget(c11634012.destg)
	e4:SetOperation(c11634012.desop)
	c:RegisterEffect(e4)
	 --level
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11634012,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,116340120)
	e3:SetTarget(c11634012.sptg)
	e3:SetOperation(c11634012.spop)
	c:RegisterEffect(e3)
end
function c11634012.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x102)
end
function c11634012.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c11634012.desfilter(c)
	return c:IsSetCard(0x102)
end
function c11634012.thfilter(c)
	return c:IsCode(31443476,36092504) and c:IsAbleToHand()
end
function c11634012.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c11634012.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11634012.desfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c11634012.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c11634012.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11634012.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11634012.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT) then	  
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c11634012.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x102) and Duel.GetMZoneCount(tp,c)>0
end
function c11634012.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11634012.cfilter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c11634012.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c11634012.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11634012.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local c=e:GetHandler()	
	if ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not c:IsAbleToExtra() or Duel.SelectOption(tp,aux.Stringid(11634012,0),1152)==1) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	if Duel.GetOperatedGroup():GetCount()>0 and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
