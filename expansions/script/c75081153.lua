--希望女神 夏慈
function c75081153.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75081153,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,75081153)
	e1:SetTarget(c75081153.spstg)
	e1:SetOperation(c75081153.spsop)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75081153,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,75081154)
	e2:SetCondition(c75081153.thcon)
	e2:SetTarget(c75081153.thtg)
	e2:SetOperation(c75081153.thop)
	c:RegisterEffect(e2)  
	--Send to extra
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75081153,3))
	e4:SetCategory(CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,75081155)
	e4:SetCondition(c75081153.tecon)
	e4:SetTarget(c75081153.tetg)
	e4:SetOperation(c75081153.teop)
	c:RegisterEffect(e4) 
end
function c75081153.filter(c,tp)
	return c:IsFaceupEx() and c:IsSetCard(0x6754) and Duel.GetMZoneCount(tp,c)>0
end
function c75081153.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c75081153.filter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,c,tp)
	if chk==0 then return #g>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75081153.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c75081153.filter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,1,1,aux.ExceptThisCard(e),tp)
	if Duel.Destroy(g,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c75081153.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_HAND)
end
function c75081153.thfilter(c)
	return c:IsSetCard(0x6754) and c:IsAbleToHand()
end
function c75081153.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75081153.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c75081153.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75081153.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c75081153.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x6754)
end
function c75081153.tecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c75081153.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75081153.tefilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE)
end
function c75081153.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75081153,5))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75081153.tefilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end