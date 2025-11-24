--闪耀的绿宝石 绯田美琴
function c28317054.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--shhis pendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28317054,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,28317054)
	e1:SetCondition(c28317054.spcon)
	e1:SetTarget(c28317054.sptg)
	e1:SetOperation(c28317054.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c28317054.thtg)
	e2:SetOperation(c28317054.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c28317054.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsFaceup()
end
function c28317054.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28317054.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c28317054.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c28317054.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:IsAbleToHand()
	local b2=Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if not c:IsRelateToEffect(e) or not (b1 and b2) then return end
	if c:IsAbleToHand() and (not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetMZoneCount(tp)<=0 or Duel.SelectOption(tp,1190,1152)==0) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		if not c:IsLocation(LOCATION_HAND) then return end
	else
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
	if #tg==0 then return end
	Duel.HintSelection(tg)
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
function c28317054.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28317054.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res=e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and re and 1 or 0
	e:SetLabel(res)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28317054.desfilter(c)
	return c:IsSetCard(0x283) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToRemove()
end
function c28317054.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c28317054.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc or Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_HAND) then return end
	Duel.ConfirmCards(1-tp,tc)
	if e:GetLabel()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.SelectMatchingCard(tp,c28317054.desfilter,tp,LOCATION_DECK,0,1,1,nil)
	if e:GetHandler():IsRelateToEffect(e) then tg:AddCard(e:GetHandler()) end
	Duel.Destroy(tg,REASON_EFFECT,LOCATION_REMOVED)
end
