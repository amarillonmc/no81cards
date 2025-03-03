--闪耀的绿宝石 绯田美琴
function c28317054.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--shhis pendulum return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28317054,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c28317054.retcon)
	e1:SetTarget(c28317054.rettg)
	e1:SetOperation(c28317054.retop)
	c:RegisterEffect(e1)
	--shhis spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28317054,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,28317054)
	e2:SetCondition(c28317054.spcon)
	e2:SetTarget(c28317054.sptg)
	e2:SetOperation(c28317054.spop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c28317054.thtg)
	e3:SetOperation(c28317054.thop)
	c:RegisterEffect(e3)
end
function c28317054.chkfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsFaceup()
end
function c28317054.retcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28317054.chkfilter,1,nil)
end
function c28317054.gthfilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToHand()
end
function c28317054.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local pg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if chk==0 then return Duel.IsExistingMatchingCard(c28317054.gthfilter,tp,LOCATION_GRAVE,0,1,nil)
		and pg:IsExists(Card.IsAbleToHand,1,nil) and Duel.GetCurrentChain()==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,pg,#pg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c28317054.retop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c28317054.gthfilter,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c28317054.gthfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
		g:Merge(tg)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c28317054.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsFaceup()
end
function c28317054.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28317054.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c28317054.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28317054.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28317054,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
function c28317054.dthfilter(c)
	return c:IsSetCard(0x283) and (c:IsType(TYPE_MONSTER) or Duel.IsExistingMatchingCard(nil,c:GetControler(),LOCATION_PZONE,0,1,nil)) and c:IsAbleToHand()
end
function c28317054.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28317054.dthfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28317054.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c28317054.dthfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
