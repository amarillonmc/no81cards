--判决牢狱的看守 ES
function c19209511.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--pendulum effect
	--illumination spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1152)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,19209511)
	e1:SetTarget(c19209511.sptg)
	e1:SetOperation(c19209511.spop)
	c:RegisterEffect(e1)
	--untargetable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_ONFIELD+LOCATION_REMOVED,0)
	e2:SetTarget(c19209511.indtg)
	e2:SetValue(c19209511.tgval)
	c:RegisterEffect(e2)
	--monster effect
	--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,19209512)
	e3:SetTarget(c19209511.pentg)
	e3:SetOperation(c19209511.penop)
	c:RegisterEffect(e3)
end
function c19209511.tdfilter(c)
	return c:IsSetCard(0x3b50) and c:IsAbleToDeck() and c:IsFaceupEx() and Duel.GetMZoneCount(tp,c)>0 and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
end
function c19209511.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c19209511.tdfilter(chkc) end
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(c19209511.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c19209511.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c19209511.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and Duel.GetMZoneCount(tp)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c19209511.indtg(e,c)
	return c:IsSetCard(0x3b50) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsFaceupEx()
end
function c19209511.tgval(e,re,rp)
	return rp==1-e:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER)
end
function c19209511.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and g:CheckSubGroup(aux.gffcheck,2,2,Card.IsSetCard,0x3b50,Card.IsCode,19209549) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c19209511.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:SelectSubGroup(tp,aux.gffcheck,false,2,2,Card.IsSetCard,0x3b50,Card.IsCode,19209549)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
