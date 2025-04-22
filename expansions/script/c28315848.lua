--闪耀的绿宝石 七草日花
function c28315848.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--shhis pendulum return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28315848,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c28315848.retcon)
	e1:SetTarget(c28315848.rettg)
	e1:SetOperation(c28315848.retop)
	c:RegisterEffect(e1)
	--shhis spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28315848,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,28315848)
	e2:SetCondition(c28315848.spcon)
	e2:SetTarget(c28315848.sptg)
	e2:SetOperation(c28315848.spop)
	c:RegisterEffect(e2)
end
function c28315848.chkfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsFaceup()
end
function c28315848.retcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28315848.chkfilter,1,nil)
end
function c28315848.rthfilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToHand() and c:IsFaceup()
end
function c28315848.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local pg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if chk==0 then return Duel.IsExistingMatchingCard(c28315848.rthfilter,tp,LOCATION_REMOVED,0,1,nil) 
		and pg:IsExists(Card.IsAbleToHand,1,nil) and Duel.GetCurrentChain()==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,pg,#pg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c28315848.retop(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if not Duel.IsExistingMatchingCard(c28315848.rthfilter,tp,LOCATION_REMOVED,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c28315848.rthfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	tg:Merge(pg)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
function c28315848.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function c28315848.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28315848.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c28315848.tgfilter(c)
	return aux.IsCodeListed(c,28335405) and c:IsAbleToGrave()
end
function c28315848.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(c28315848.tgfilter,tp,LOCATION_DECK,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28315848.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c28315848.tgfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c28315848.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
