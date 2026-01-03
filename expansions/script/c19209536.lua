--判决牢狱的囚犯 09榧野尊
function c19209536.initial_effect(c)
	aux.AddCodeList(c,19209511,19209542)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum effect
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,19209536)
	e1:SetCondition(c19209536.thcon)
	e1:SetTarget(c19209536.thtg)
	e1:SetOperation(c19209536.thop)
	c:RegisterEffect(e1)
	--monster effect
	--to pzone
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19209537)
	e2:SetTarget(c19209536.pztg)
	e2:SetOperation(c19209536.pzop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	Debug.Message(1)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,19209538)
	e4:SetCondition(c19209536.spcon)
	e4:SetTarget(c19209536.sptg)
	e4:SetOperation(c19209536.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e5)
	Debug.Message(2)
	Debug.Message(e4)
	--test
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetTarget(c19209536.sptg)
	e6:SetOperation(c19209536.spop)
	c:RegisterEffect(e6)
end
function c19209536.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,e:GetHandler(),19209511)
end
function c19209536.thfilter(c)
	return aux.IsCodeListed(c,19209511) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c19209536.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209536.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19209536.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c19209536.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c19209536.pfilter(c)
	return c:IsCode(19209511) and not c:IsForbidden()
end
function c19209536.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
		and Duel.IsExistingMatchingCard(c19209536.pfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c19209536.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and Duel.CheckLocation(tp,LOCATION_PZONE,0)
		and Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c19209536.pfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c19209536.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return true--c:IsReason(REASON_EFFECT) and c:IsLocation(LOCATION_EXTRA+LOCATION_GRAVE)
end
function c19209536.spfilter(c,e,tp)
	return c:IsCode(19209542) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function c19209536.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end--Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c19209536.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	local c=e:GetHandler()
	local ct=0
	if c:IsReason(REASON_EFFECT) then ct=ct+1 end
	if c:IsLocation(LOCATION_EXTRA+LOCATION_GRAVE) then ct=ct+2 end
	if Duel.GetMZoneCount(tp)>0 then ct=ct+4 end
	if Duel.IsExistingMatchingCard(c19209536.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) then ct=ct+8 end
	Debug.Message(ct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c19209536.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19209536.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
